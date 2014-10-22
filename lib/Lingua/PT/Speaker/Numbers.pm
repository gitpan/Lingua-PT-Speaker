package Lingua::PT::Speaker::Numbers;

use Text::RewriteRules;

use strict;
our %letra;
our $marca;

BEGIN {
  %letra = (
	    a=>" � ",
	    b=>" b� ",
	    c=>" c� ",
	    d=>" d� ",
	    e=>" � ",
	    f=>" efe ",
	    g=>" gu� ",
	    h=>" ag� ",
	    i=>" � ",
	    j=>" j�ta ",
	    k=>" kapa ",
	    l=>" �le ",
	    m=>" �me ",
	    n=>" �ne ",
	    o=>" � ",
	    p=>" p� ",
	    q=>" qu� ",
	    r=>" �rre ",
	    s=>" �sse ",
	    t=>" t� ",
	    u=>" � ",
	    v=>" v� ",
	    w=>" dobliu ",
	    x=>" xis ",
	    y=>" ipsilon ",
	    z=>" z� ",

	    '~' =>" til ",
	    ':' =>" dois pontos ",
	    '-' =>" �fen ",
	    '_' =>" sublinhado ",
	    '/' =>" barra ",
	    '=' => ' igual ',
	    '*' => ' asterisco ',
	    '<' => ' menor ',
	    '>' => ' maior ',
	    '|' => ' barra ',
	    '#' => ' cardinal ',
	    "\cM" => ' nova p�gina ',
	   );

  $marca = "\0x1";
}

RULES email
\n==>
$marca\.==> ponto $marca
$marca\@==> arroba $marca
$marca:\/\/==> doispontos barra barra $marca
$marca:==> doispontos $marca
$marca(net)\b==> n�te $marca
$marca(www)\b==> dabliudabliudabliu $marca
$marca(http)\b==> g�t�t�p� $marca
$marca(com)\b==> c�me $marca
$marca(org)\b==> orgue $marca
$marca(http|[a-zA-Z]{1,3}?)\b=e=>join("",map {$letra{lc($_)}} split(//,$1)).", $marca"
$marca(.+?)\b==>$1 $marca
$marca$==>
^==>$marca!! not(/\s/)
ENDRULES

RULES nontext
(\w)-(\w)==>$1 $2
([\-*=<>#\|\~_/\cM:])=e=>$letra{$1}
ENDRULES

RULES number
(\d+)(000000)\b==>$1 milh�o!!            $1 == 1
(\d+)(000000)\b==>$1 milh�es
(\d+)(000)(\d{3})==>$1 milh�o e $3!!     $1 == 1
(\d+)(\d{3})(000)==>$1 milh�o e $2 mil!! $1 == 1
(\d+)(\d{6})==>$1 milh�o, $2!!           $1 == 1
(\d+)(000)(\d{3})==>$1 milh�es e $3
(\d+)(\d{3})(000)==>$1 milh�es e $2 mil
(\d+)(\d{6})==>$1 milh�es, $2

(\d+)(000)\b==>mil!!                     $1 == 1
(\d+)(000)\b==>$1 mil
(\d+)0(\d{2})==>mil e $2!!               $1 == 1
(\d+)(\d00)==>mil e $2!!                 $1 == 1
(\d+)(\d{3})==>mil $2!!                  $1 == 1
(\d+)0(\d{2})==>$1 mil e $2
(\d+)(\d00)==>$1 mil e $2
(\d+)(\d{3})==>$1 mil, $2

100==>cem 
1(\d\d)==>cento e $1 
0(\d\d)==>$1
200==>duzentos 
300==>trezentos 
400==>quatrocentos 
500==>quinhentos 
600==>seiscentos 
700==>setecentos 
800==>oitocentos 
900==>novecentos 
(\d)(\d\d)==>${1}00 e $2

10==>dez 
11==>onze 
12==>doze 
13==>treze 
14==>catorze 
15==>quinze 
16==>dezasseis 
17==>dezassete 
18==>dezoito 
19==>dezanove 
20==>vinte 
30==>trinta 
40==>quarenta 
50==>cinquenta 
60==>sessenta 
70==>setenta 
80==>oitenta 
90==>noventa 
0(\d)==>$1
(\d)(\d)==>${1}0 e $2

1==>um 
2==>dois 
3==>tr�s 
4==>quatro 
5==>cinco 
6==>seis 
7==>sete 
8==>oito 
9==>nove 
0$==>zero 
0==> 
  ==> 
 ,==>,
ENDRULES

RULES ordinais
(\d)\.([��])==>$1$2
\b1000000�==>milion�simo
\b1000000�==>milion�sima
\b1000�==>mil�simo
\b1000�==>mil�sima 

([2-9]\d\d)([��])==>$1 $2

\b1(\d\d\d)([��])==>1000$2 $1$2

(\d\d\d\d)([��])==>$1 $2

100�==>cent�simo
200�==>ducent�simo
300�==>tricent�simo
400�==>quadrigent�simo
500�==>quingent�simo
600�==>sexcent�simo
700�==>septingent�simo
800�==>octingent�simo
900�==>nongent�simo

100�==>cent�sima 
200�==>ducent�sima
300�==>tricent�sima
400�==>quadrigent�sima
500�==>quingent�sima
600�==>sexcent�sima
700�==>septingent�sima
800�==>octingent�sima
900�==>nongent�sima

(\d)(\d)(\d)�==>${1}00� ${2}0� ${3}�
(\d)(\d)(\d)�==>${1}00� ${2}0� ${3}�

10�==>d�cimo
20�==>vig�simo
30�==>trig�simo
40�==>quadrag�simo
50�==>quinquag�simo
60�==>sexag�simo
70�==>septuag�simo
80�==>octog�simo
90�==>nonag�simo

10�==>d�cima 
20�==>vig�sima 
30�==>trig�sima 
40�==>quadrag�sima 
50�==>quinquag�sima 
60�==>sexag�sima 
70�==>septuag�sima 
80�==>octog�sima 
90�==>nonag�sima 
(\d)(\d)�==>${1}0� $2�
(\d)(\d)�==>${1}0� $2�

1�==>primeiro 
2�==>segundo 
3�==>terceiro 
4�==>quarto 
5�==>quinto 
6�==>sexto 
7�==>s�timo 
8�==>oitavo 
9�==>nono 
�==> �simo

1�==>primeira 
2�==>segunda 
3�==>terceira 
4�==>quarta 
5�==>quinta 
6�==>sexta 
7�==>s�tima 
8�==>oitava 
9�==>nona 
�==> �sima  

  ==> 
ENDRULES

1;
