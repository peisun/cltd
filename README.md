cltd
====

ChangeLogファイルをtDiaryにポストするツール

ChangeLogファイルを日記に使う

こちらを参照してください。
http://0xcc.net/unimag/1/

こちらを読むのもよいでしょう。
http://www.hyuki.com/yukiwiki/wiki.cgi?ChangeLog

tDiaryについては
http://www.tdiary.org/
を参照してください。

作者はChangeLogファイルを用いて日記（というかメモ）を書いてきました。
(http://www.shudoshiki.net/~pei/diary/index.html)
このときは、chalowというツールを使っていました。(http://chalow.org/cl/)

しばらく更新をサボっていたのですが他のblogサービスと同様にブラウザから
入力するということと、ChangeLogファイルを捨てきれないという理由から
このツールを作ることにしました。

chalowでもよかったのですが、OS-Xのバージョンをあげたところでライブラリが
使えなくなり、また使えるようにするにはどうしたらよいかという努力を怠った
ので、使わなくなりました。


#前提条件


cltdは、Ruby 2.0.0p247(2013-06-27 revision 41674)[x86_64-darwin11.4.2]
で動作確認しました。

開発環境はMacBoox(2008 Later) OS-X 10.7.5です。


#インストール


cltd.rbをPATHの通ったところに置くか、適当にディレクトリを作って
そこにPATHを通してください。

特に必要なgemはありません。
というか、gemがよく分かっていないので使っていません。
たぶん、使うほどのことはしていません。



#概要


cltdはChangeLogの記述内容から、日ごとの記述をtDiaryにポストします。
但し、タイトルは付けません（今のところ）

かといって、ChangeLogの記述内容をすべてpostするわけではありません。
オプション指定ができますが、最新の1日分をpostします。

最新の1日分は、ChangeLogのファイル先頭にある日付の内容です。
たとえ、一週間ChangeLogを書いてなかろうがです。


#使い方


cltdのPATHが通っているか、以下で確認できるかと思います。

    $ cltd.rb -help

最初に設定ファイルを作ります。


    server = http://hogehoge/update.rb
    user = upnushi
    diary = ~/Dropbox/diary/diary.txt

を書いたファイルをchlog.confをして保存します。
* hogehogeは自分の使うサーバーのURLを使用してください。
* upnushiはtDiaryのIDを使用してください。
* diaryには、自分のChangeLogファイルを指定してください。

cltdはこのファイルを頼りに、tDiaryにpostします。

    $ ./cltd.rb -c chlog.conf
    Config: chlog.conf
    Diary: ~/Dropbox/diary/diary.txt
    tDiary URL = http://localhost/~peisunstar/tDiary/update.rb
    User ID = peisunstar
    Please passwd:
    posted lastest 2013-07-15
    $

とすれば、ChangeLogファイルを読み込み、tDiaryにpostします。

-c で指定するファイル名はchlog.confでなくても構いません。
hogeでもよいです。

    $ cltd.rb -c hoge

毎度毎度、-c オプションを指定するのが面倒な場合は、$HOME/.cltd.confに
同じ内容のものを書いておくとよいでしょう。


#オプション

cltd.rbに-helpを指定すると、オプションが表示されます。

    $ ./cltd.rb -help
    Usage: cltd [options]
         -c config file
         -f changlog file
         -l the lastest days
         -d the date YYYY-MM-DD,..

-c は先ほどの通り設定ファイルを指定します。

-f ChangeLogファイルを指定します。confファイルに指定されていないファイルを指定
   することができます。

-l でフォルトでは最新1日分がpostされますが、postしたい最新日数を指定できます。

-d 最新ではなく、指定した日付の内容をpostできます。

-lと-dが両方指定された場合は、-dが優先されます。


#cltdにおけるChangeLogの特殊な記法


tDiaryの記法はtDiary wikiのみをサポートしています。

## タイトル(tDiaryのタイトルではない)
cltdはtDiaryでいうところのタイトルをサポートしていません。  
ChangeLogで 「*」が付いたところをtDiaryでいうところのサブタイトルとして扱います。  
訳が分からなくなるので、サブタイトルで統一します。

#サブタイトルと同じ行に続けて書いたものはダメです

ChangeLogでは、

    * hogehoge: 今日はよい天気でした

というように書けるのですが、これはサポートしていません。  
以下のように書いてください。

    * hogehoge
            今日はよい天気でした。



## 引用
tDiaryの引用は、行頭にタブ（もしくはスペース？）を入れると引用になるのですが、
タブを入れるのが面倒なので、[src] 〜 [/src]のように書けるようにしています。

   [src]
   いんようだよぉん。
   [/src]

[src],[src]には改行を入れます。
まぁ、ようは[src]と[/src]に挟まれた行が引用になります。

また、>>〜<<も引用になります。

    >>
    引用です
    <<
    引用からはずれます


## リスト項目
tDiaryのリスト項目は「*」ですが、これはChangeLogとかぶってしまうので、「-」で
代用しています。(chalowの仕様だったと思います)

    - リスト項目1
    - リスト項目2

番号付きのリスト項目はtDiaryの通り「#」でいけるはずです。


## amazon.rbプラグイン
作者はamazonプラグインを使用しています。記法がどうしても覚えられないので
以下のようにしました。

    amazon:123-456789

amazon:に続いて、ISBNなりASBNを続けます。
これなら覚えられます。


#その他


cltdは作者が必要だと思った機能を実装しただけのものになっています。

メンテナンスは作者のペースでするつもりですが、とりわけ必要なものも現段階では
ないので・・・ごにょごにょ


#ライセンス


ライセンスはGPL v2です。





