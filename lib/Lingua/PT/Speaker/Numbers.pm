package Lingua::PT::Speaker::Numbers;

use Text::RewriteRules;

use strict;
our %letra;
our %mat;

BEGIN {
  %letra = (
	    a=>"á",
	    b=>"bê",
	    c=>"cê",
	    d=>"dê",
	    e=>"é",
	    f=>"éfe",
	    g=>"guê",
	    h=>"agá",
	    i=>"í",
	    j=>"jóta",
	    k=>"kápa",
	    l=>"éle",
	    m=>"éme",
	    n=>"éne",
	    o=>"ó",
	    p=>"pê",
	    q=>"quê",
	    r=>"érre",
	    s=>"ésse",
	    t=>"tê",
	    u=>"ú",
	    v=>"vê",
	    w=>"dablew",
	    x=>"xís",
	    y=>"ípsilon",
	    z=>"zê",

	    '~' =>" til ",
	    ':' =>" dois pontos ",
	    '-' =>" ífen ",
	    '_' =>" sublinhado ",
	    '/' =>" barra ",
	    '=' => ' igual ',
	    '*' => ' asterisco ',
	    '<' => ' menor ',
	    '>' => ' maior ',
	    '|' => ' barra ',
	    '#' => ' cardinal ',
            '%' => ' por cento ',
	    "\cM" => ' nova página ',
	   );

  %mat = (
	    '~' =>" til ",
	    ':' =>" dois pontos ",
	    '-' =>", menos ",
	    '_' =>" sublinhado ",
	    '/' =>" sobre ",
	    '$' =>" dólar ",
	    '=' => ', igual ',
	    '=>' => ', implica ',
	    '<=>' => ', equivale a ',
	    '^' => ' elevado a ',
	    '/\\' => ' ii ',
	    '\/' => ', ouu ',
	    '+' => ', mais ',
	    '*' => ' vezes ',
	    '<' => ', menor ',
	    '>' => ', maior ',
	    '|' => ' barra ',
	    '!' => ' factorial ',
            '%' => ' por cento ',
	    '#' => ' cardinal de ',
	   );

}

RULES/m email
\n==>
\.==> ponto 
\@==> arroba 
:\/\/==> doispontos barra barra 
:==> doispontos 
(net)\b==> néte 
(www)\b==> dablidablidabliw 
(http)\b==> agátêtêpê 
(com)\b==> cóme 
(org)\b==> órg 
#([a-zA-Z]{1,3}?)\b=e=>join("",map {$letra{lc($_)}} split(//,$1)).", "
([a-zA-Z]{1,3}?)\b=e=>" ".sigla($1). " "
(.+?)\b==>$1 
ENDRULES

RULES/m acron
e(?=[nm])==>ê
a==>á
e==>é
i==>í
o==>ó
u==>ú
ENDRULES

RULES/m sigla
([a-zA-Z])=e=>$letra{lc($1)} || " $1 "
ENDRULES

RULES/m math
\b([a-z])\b\s*2\b==> $letra{$1} ao quadrado 
\b([a-z])\b\s*3\b==> $letra{$1} ao cubo 
\b([a-z])\b\s*(\d)\b==> $letra{$1} à $2ª 
([^\w\s]+)==> $mat{$1} !! defined $mat{$1}
\b([a-z])\b==> $letra{$1} 
\bcos\b==>cosseno de
\bs[ie]n\b==>seno de
\blog\b==>logaritmo de 
\bexp\b==>exponencial de 
\bsqrt\b==>raíz de 
\bmod\b==>módulo de 
ENDRULES

RULES/m nontext
(\w)-(\w)==>$1 $2
([\-*=<>#\|\~_/\cM:%])=e=>" $letra{$1} "
ENDRULES

RULES number
(\d+)\s*\%==>$1 por cento
(\d+)\.(\d+)==>$1 ponto $2
(\d+)(000000)\b==>$1 milhão!!            $1 == 1
(\d+)(000000)\b==>$1 milhões
(\d+)(000)(\d{3})==>$1 milhão e $3!!     $1 == 1
(\d+)(\d{3})(000)==>$1 milhão e $2 mil!! $1 == 1
(\d+)(\d{6})==>$1 milhão, $2!!           $1 == 1
(\d+)(000)(\d{3})==>$1 milhões e $3
(\d+)(\d{3})(000)==>$1 milhões e $2 mil
(\d+)(\d{6})==>$1 milhões, $2

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
3==>três 
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
(\d)\.([ºª])==>$1$2
\b1000000º==>milionésimo
\b1000000ª==>milionésima
\b1000º==>milésimo
\b1000ª==>milésima 

([2-9]\d\d)([ºª])==>$1 $2

\b1(\d\d\d)([ºª])==>1000$2 $1$2

(\d\d\d\d)([ºª])==>$1 $2

100º==>centésimo
200º==>ducentésimo
300º==>tricentésimo
400º==>quadrigentésimo
500º==>quingentésimo
600º==>sexcentésimo
700º==>septingentésimo
800º==>octingentésimo
900º==>nongentésimo

100ª==>centésima 
200º==>ducentésima
300º==>tricentésima
400º==>quadrigentésima
500º==>quingentésima
600º==>sexcentésima
700º==>septingentésima
800º==>octingentésima
900º==>nongentésima

(\d)(\d)(\d)º==>${1}00º ${2}0º ${3}º
(\d)(\d)(\d)ª==>${1}00ª ${2}0ª ${3}ª

10º==>décimo
20º==>vigésimo
30º==>trigésimo
40º==>quadragésimo
50º==>quinquagésimo
60º==>sexagésimo
70º==>septuagésimo
80º==>octogésimo
90º==>nonagésimo

10ª==>décima 
20ª==>vigésima 
30ª==>trigésima 
40ª==>quadragésima 
50ª==>quinquagésima 
60ª==>sexagésima 
70ª==>septuagésima 
80ª==>octogésima 
90ª==>nonagésima 
(\d)(\d)º==>${1}0º $2º
(\d)(\d)ª==>${1}0ª $2ª

1º==>primeiro 
2º==>segundo 
3º==>terceiro 
4º==>quarto 
5º==>quinto 
6º==>sexto 
7º==>sétimo 
8º==>oitavo 
9º==>nono 
º==> ésimo

1ª==>primeira 
2ª==>segunda 
3ª==>terceira 
4ª==>quarta 
5ª==>quinta 
6ª==>sexta 
7ª==>sétima 
8ª==>oitava 
9ª==>nona 
ª==> ésima  

  ==> 
ENDRULES

1;
