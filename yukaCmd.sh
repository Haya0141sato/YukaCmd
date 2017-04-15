#!/bin/sh


##############ここからライセンス文#################
#The MIT License
#Copyright (c) 2017 Haya0141sato
#
#以下に定める条件に従い、本ソフトウェアおよび関連文書のファイル（以下「ソフトウェア」）の複製を取得するすべての人に対し、ソフトウェアを無制限に扱うことを無償で許可します。これには、ソフトウェアの複製を使用、複写、変更、結合、掲載、頒布、サブライセンス、および/または販売する権利、およびソフトウェアを提供する相手に同じことを許可する権利も無制限に含まれます。
#
#上記の著作権表示および本許諾表示を、ソフトウェアのすべての複製または重要な部分に記載するものとします。
#
#ソフトウェアは「現状のまま」で、明示であるか暗黙であるかを問わず、何らの保証もなく提供されます。ここでいう保証とは、商品性、特定の目的への適合性、および権利非侵害についての保証も含みますが、それに限定されるものではありません。 作者または著作権者は、契約行為、不法行為、またはそれ以外であろうと、ソフトウェアに起因または関連し、あるいはソフトウェアの使用またはその他の扱いによって生じる一切の請求、損害、その他の義務について何らの責任も負わないものとします。 

#############ライセンス文ここまで################


#他のボイロ(EXへのアップデートも含む)だと変わる内容です。他のボイロなら適宜置き換えて下さい。
yukariWindowName="VOICEROID＋ 結月ゆかり" #xwininfoで指定するウィンドウ名

#他のボイロ(EXへのアップデートも含む)だと変わるかも知れない内容です。
yukariButtonX=50 #ウィンドウの左下を(0,0)としたときの再生ボタンのX位置
yukariButtonY=50 #ウィンドウの左下を(0,0)としたときの再生ボタンのY位置
yukariTDY=20 #再生ボタンのクリック位置からテキストエリアまでのY位置の差の絶対値


####大幅な改変しない限りこの下は基本いじる必要がない####

#コマンドの存在を確認する
#コマンドの一覧を入れた変数を第一引数に指定し、そのコマンドが存在しなければスクリプトを終了する。
status=0
coms="awk xsel xdotool xwininfo " #必要なコマンドの一覧
for li in ${coms} #必要なコマンドの一覧
	do
which ${li} > /dev/null 2>&1
comstatus=${?}
if [ 0 -ne ${comstatus} ]
		then
echo "${li} コマンドをインストールして下さい。"
		fi
status=`expr ${status} + ${comstatus}`
	done

if [ 0 -ne ${status} ]
	then
exit 
	fi

if [ 1 -le ${#} ]
then
readVoice=${1}

#<変数名>:<値>という形の変数の集合を、スペースで区切るタイプの変数一覧から変数を取り出す関数。
#第一引数に変数一覧、第二引数に変数の名前を入れることでその変数の値を取得できます
getValue()
	{
valuelist=${1}
valuelist=`echo ${valuelist} | awk '{gsub(": ",":",$0);print $0}'`
valuelist=`echo ${valuelist} | awk '{gsub(" :",":",$0);print $0}'`

value=${2}

ret=${valuelist#*${value}:}
ret=${ret%% *}

echo $ret
	}
#xwininfoの設定をいろいろ変数に格納
yukariInfo=`xwininfo -name "${yukariWindowName}"`
if [ ${?} -ne 0 ]
	then
echo "${yukariWindowName}を起動して下さい。"
exit
	fi
yukariWindowID=`getValue "${yukariInfo}" "Window id"`
yukariWindowX=`getValue "${yukariInfo}" "Absolute upper-left X"`
yukariWindowY=`getValue "${yukariInfo}" "Absolute upper-left Y"`
yukariWindowHeight=`getValue "${yukariInfo}" "Height"`
yukariButtonX=`expr ${yukariButtonX} + ${yukariWindowX}`
yukariButtonY=`expr ${yukariWindowHeight} - ${yukariButtonY}`
yukariButtonY=`expr ${yukariButtonY} + ${yukariWindowY}`


#ゆかりさんに喋らせる


#特にオプションとかない場合普通にクリップボードに転送
echo "${1}" | xsel --clipboard --input
#オプションがついてた場合それに対応する。
if [ 1 -lt ${#} ]
	then
while getopts f: OPT
		do
case $OPT in
"f" ) cat "${2}" | xsel --clipboard --input
esac
		done
	fi

#コマンドを入れた後元に戻すための設定を用意
nowMouseLocate=`xdotool getmouselocation`
x=`getValue "${nowMouseLocate}" x`
y=`getValue "${nowMouseLocate}" y`

#テキストエリアにフォーカスし、テキストエリアの既存の中身を消す
xdotool mousemove ${yukariButtonX} ${yukariButtonY} 
xdotool mousemove_relative 0 -${yukariTDY}
xdotool click --window ${yukariWindowID} 1
xdotool key --window ${yukariWindowID} ctrl+a
xdotool key --window ${yukariWindowID} BackSpace
#クリップボードから貼り付け
xdotool key --window ${yukariWindowID} ctrl+v
#あとは再生をクリックで完了
xdotool mousemove ${yukariButtonX} ${yukariButtonY} 
xdotool click --window ${yukariWindowID} 1

#最後に元の状態に戻す
xdotool mousemove ${x} ${y}
else #こっから全部コマンドのマニュアル
echo "

ゆかりさんをコマンドラインからしゃべらせるコマンドの使い方


\$$0 [文字列]
\$$0 [オプション] [対応する値]

注意

本来VOICEROIDはwindows上での動作を前提としたソフトウェアであり、株式会社エーアイ及び株式会社AHSが権利を保有しています。
このプログラムは株式会社エーアイ及び株式会社AHSとは無関係です。
動作保証のない環境での使用となるため、このソフトの作者は一切の責任を負いません。また、動作を保証しません。このソフトのご利用及びこの手順書に書かれている内容の実行に関しては自己責任でお願いします。


事前準備


※ 昔やったことを思い出してるだけなのであまりあてになりません。要するにwineを使ってゆかりさんが動くようにして下さいという内容です。

1.AHSの公式から、VOICEROID+ 結月ゆかりを購入し、wineでインストールする。
インストール方法に関しては割愛しますが、大まかな流れとしてはwineと各種ライブラリ(覚えている限りでは、少なくともd3dx9とdirectplayはアクティベーションに必要でした。とりあえずwinetricksでインストールできるものは全てインストールしたほうがいいかも)をインストールした後フォントの設定を直し、
インストール用ディスクの中身をHDDにコピーし、その中のsetup.exeを以下のコマンドで起動することでインストールが可能なはずです。
正直うろ覚えなので、googleで「wine 結月ゆかり」等で検索して下さい。
\$LANG=ja_JP.utf-8 wine setup.exe

(フォントの設定に関して)

~/.wine/user.regの
[Software\\\\\\\\Wine\\\\\\\\Fonts\\\\\\\\Replacement]
がある項目の
\"hoge\"=\"fuga\"
のfugaにあたる部分を全てインストール済みのフォントに書き換えます。
(インストール済みのフォントの一覧は、fc-listコマンドで見れるので、その中から使いたいものを選んで下さい。フォントのインストールをしたいのであれば、ttfファイル等のフォントファイルを~/.fonts/に放り込んでください。~/.fonts/がない場合新しく作って下さい。)



ゆかりさんのインストール後はどうするか

大まかな流れ

1.ゆかりさんを起動する
2.このスクリプトを使う


1.インストールしたらwineでVOICEROID+ 結月ゆかりを起動する

まずインストールした場所まで移動する
例:
\$cd ~/.wine/drive_c/Program\\ Files\\ \\(x86\\)/AHS/VOICEROID+/yukari

次に起動する。この時、言語設定を入れて起動しないと文字化けする

\$LANG=ja_JP.utf-8 wine VOICEROID.exe


2.この状態でこのスクリプトを使用すると、ゆかりさんがしゃべります

\$$0 \"文字列\"

例
\$$0 \"ゆかりさんもlinuxの世界に進出しましたよ!\"

オプションについて

-f ファイル名
テキストファイルとして読み込みます。その際使用できる文字コードはUTF-8です。
"
fi
