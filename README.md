# 連分数を用いた数値積分によるc, fortran, juliaの速度比較

Linux/UNIX（とOS X)用です。
CとFortranはgit cloneしたディレクトリで、以下のようにコンパイルして実行してください。

	make
	./e1_cf_c.exe
	./e1_cf_f.exe

Juliaは以下のように実行してください。

	julia e1_cf.jl

手元の環境の計算部分の経過時間の比はFortran:C:Julia = 1:3.2:4.9でした。不安なぐらいFortranが速いですね！

もっとJuliaを速くできるなど、ソースコードに問題があれば、御指摘をお願いします。
