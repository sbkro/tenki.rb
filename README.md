### これって何？
ターミナル.appなどUNIX系シェルプログラムから週間天気予報を表示するためのスクリプトです。ターミナルからいちいちスクリプトを呼び出すの？と思いますが、[Total Terminal](http://totalterminal.binaryage.com)などショートカットでシェルを呼び出せるプログラムと組み合わせるとかなり使い勝手が良くなります。

このスクリプトには、livedoorの「Weather Hacks」を利用しています。素晴らしいAPIありがとう。
* http://weather.livedoor.com/weather_hacks/

### インストール
* tenki.rbをパスの通った場所へコピーしてください。
* （注意）Rubyがインストールされていない場合は、別途インストールしてください。

### 使い方
自動的にRubyコマンドが呼ばれるようになっています。ターミナルから以下のコマンドを実行してください。
```
$ tenki.rb <都市コード>
```
都市コードは、以下のページにまとめました。ご確認ください。
* [tenki.rb Wikiページ](https://github.com/sbkro/tenki.rb/wiki)

### ライセンス
MITライセンスに準拠します。

### 動作環境
* OSX 10.8 / bash 3.2.48(1)-release / Ruby 1.8.7

### 今後の予定
時間があれば、これらの機能拡張は行いたいと思います。
* 都市コードのiniファイル化
* エラー処理の充実化

### サポート
もし不具合等見つかりましたら、Githubのページまでご連絡ください。
* https://github.com/sbkro/tenki.rb
