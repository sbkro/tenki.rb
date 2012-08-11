#!/usr/bin/ruby
#=tenki.rb
#  日本の週間天気を表示するコマンドラインスクリプト
#
#==History
# version 1.0.0 2012/08/11 First version
#
#==Information
# このスクリプトは、「Weather Hacks」というWeb APIを利用しています。
# 詳細は、下記のURLを確認してください。素晴らしいAPIの提供ありがとう。
#
# http://weather.livedoor.com/weather_hacks/
#
#Author::    sbkro (sbkro.apps@gmail.com)
#CopyLight:: Copyright (c) 2012 sbkro-apps. All rights reserved.
#License::   MIT License

###############################################################################
# Required files
###############################################################################
require 'uri'
require 'net/http'
require 'rexml/document'


###############################################################################
# Include Modules
###############################################################################
include REXML


###############################################################################
# Constants
###############################################################################

# 一次細分区分定義表URL（XML形式）
FORECAST_MAP_URL = "http://weather.livedoor.com/forecast/rss/forecastmap.xml"

# RSSから天気情報を取得するためのXPath
XPATH_RSS_TITLE = "rss/channel/item/title"

# 一次細分区分定義表から都市の一覧を取得するためのXPath
XPATH_XML_CITY = "rss/channel/ldWeather:source/area/pref/city"

# 都市コードの初期値 (東京)
DEFAULT_CITY_CODE = 63

# 都市コードの最小値（稚内）
MIN_CITY_CODE = 1

# 都市コードの最大値（与那国島）
MAX_CITY_CODE = 143


###############################################################################
# URLからDOMオブジェクトを作成する。
#
#@param _url_s_ :: URL
#
#@return :: DOMオブジェクト
###############################################################################
def create_dom (url_s)
    uri = URI(url_s)

    Net::HTTP.version_1_2
    Net::HTTP.start(uri.host, uri.port) { |http|
        response = http.get(uri.path)
        Document.new(response.body)
    }
end


###############################################################################
# 都市コードから、週間天気が記載されているURLを取得する。
#
# 一次細分区分定義表からURLを取り出す。一次細分区分定義表から、以下の
# 要素を取り出し、city_code_iとidがマッチする要素を探索する。該当要素の
# sourceに記載されているURLを戻り値として返却する。
#
# <city title="稚内"
#          id="1"
#      source="http://weather.livedoor.com/forecast/rss/1a/1.xml" />
#
#
#@param _city_code_i_ :: 都市コード。コードの定義は一次細分区分定義表に記載
#                        されているものを利用する。初期値は「東京」とする。
#
#@return :: 都市コードに対応したURLを返却する。
###############################################################################
def search_source_url_by_city_code (city_code_i = DEFAULT_CITY_CODE)
  forecast_map = create_dom(FORECAST_MAP_URL)
  forecast_map.elements.each(XPATH_XML_CITY) { |element|
      if element.attributes['id'].to_i == city_code_i then
         return element.attributes['source']
      end
  }

  #TODO 例外出す?
end


###############################################################################
# 一次細分区分定義表から取得したURLから週間天気を取得する。
# |source_url_s|からRSSのDOMオブジェクトを取得し、|XPATH_RSS_TITLE|の要素を
# 取得する。該当要素のテキストをArrayに格納する。
#
#@param _source_url_s_ :: 一次細分区分定義のsource属性に記載されているURL
#
#@return :: 週間天気の配列
###############################################################################
def build_weather_summary (source_url_s)
    summary = Array.new
    source = create_dom(source_url_s)
    source.elements.each(XPATH_RSS_TITLE) { |element|
        summary.push(element.text)
    }
    return summary
end


###############################################################################
# 週間天気をコンソールに表示する。
# 表示内容を変更する場合このメソッドの内容を編集する。
#
#@param _sumary_list_ :: 天気予報のデータの一覧
###############################################################################
def display (summary_list)
    summary_list.each_with_index { |item, index|
        # 最初の行は、広告が入っているので削除
        if index == 0 then next end
        puts item
    }
end


###############################################################################
# コマンドライン引数の内容を検証する
#
# 検証内容は、以下のものを行う。
# * 引数の数チェック
# * 都市コードの範囲チェック
#
#@return :: True  => 引数に問題なし False => 引数に問題あり
###############################################################################
def validate_args
    # 引数の数チェック
    if ARGV.size != 1 then
        return false
    end

    # 引数の範囲チェック
    if (MIN_CITY_CODE..MAX_CITY_CODE).include?(ARGV[0].to_i) then
        return true
    else
        return false
    end
end


###############################################################################
# 使い方をコンソールに出力する
###############################################################################
def display_usage
    puts " Usage: ruby tenki.rb <CITY_CODE>\n"
end


###############################################################################
# Main
###############################################################################
city_code = DEFAULT_CITY_CODE

if validate_args then
    city_code = ARGV[0].to_i
else
    display_usage
    exit(1)
end

url = search_source_url_by_city_code(city_code)
weather =  build_weather_summary(url)
display(weather)
exit(0)


###############################################################################
# FILE_OF_END
###############################################################################
