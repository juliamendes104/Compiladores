%{
	#include <stdio.h>
	#include "analisador.tab.h"
	int linha = 1, erros = 0;
%}

%option noyywrap

DIGITO[0-9]
ID[A-Za-z][A-Za-z0-9]*
ESPACO[\t\r" "]

%%

"int" {printf("[%s] -> TIPOS\n", yytext); return INT;}
"float" {printf("[%s] -> TIPOS\n", yytext); return FLOAT;}
"double" {printf("[%s] -> TIPOS\n", yytext); return DOUBLE;}
"main" {printf("[%s] -> PALAVRA RESERVADA\n", yytext); return MAIN;}
"if" {printf("[%s] -> PALAVRA RESERVADA\n", yytext); return IF;}
"else" {printf("[%s] -> PALAVRA RESERVADA\n", yytext); return ELSE;}
"while" {printf("[%s] -> PALAVRA RESERVADA\n", yytext); return WHILE;}
"printf" {printf("[%s] -> PALAVRA RESERVADA\n", yytext); return PRINTF;}
"for" {printf("[%s] -> PALAVRA RESERVADA\n", yytext); return FOR;}
"scanf" {printf("[%s] -> PALAVRA RESERVADA\n", yytext); return SCANF;}


{ESPACO}+
"/*"[^*]*"*/"
"//"[^\n]*

{DIGITO}+{ID}+ {
	printf("[%s] -> IDENTIFICADOR INVALIDO ", yytext);
	erros++;
	printf("Linha: %d\n", linha);
}
{DIGITO}+ {printf("[%s] -> INTEIRO\n", yytext); return NUMERO;}
{DIGITO}+"."{DIGITO}+ {printf("[%s] -> REAL\n", yytext); return REAL;}
"."{DIGITO}+ {
	printf("[%s] -> INVALIDO ", yytext);
	erros++;
	printf("Linha: %d\n", linha);
}

{ID} {printf("[%s] -> IDENTIFICADOR\n", yytext); return IDENTIFICADOR;}


"+" {printf("[%s] -> OPERADORES ARITMETICOS\n", yytext); return ADICAO;}
"-" {printf("[%s] -> OPERADORES ARITMETICOS\n", yytext); return SUBTRACAO;}
"*" {printf("[%s] -> OPERADORES ARITMETICOS\n", yytext); return MULTIPLICACAO;}
"/" {printf("[%s] -> OPERADORES ARITMETICOS\n", yytext); return DIVISAO;}
"%" {printf("[%s] -> OPERADORES ARITMETICOS\n", yytext); return MODULO;}
"&&" {printf("[%s] -> OPERADORES LOGICOS\n", yytext); return E;}
"||" {printf("[%s] -> OPERADORES LOGICOS\n", yytext); return OU;}
"==" {printf("[%s] -> OPERADORES RELACIONAIS\n", yytext); return IGUAL;}
">" {printf("[%s] -> OPERADORES RELACIONAIS\n", yytext); return MAIOR;}
"<" {printf("[%s] -> OPERADORES RELACIONAIS\n", yytext); return MENOR;}
">=" {printf("[%s] -> OPERADORES RELACIONAIS\n", yytext); return MAIORIGUAL;}
"<=" {printf("[%s] -> OPERADORES RELACIONAIS\n", yytext); return MENORIGUAL;}
"!=" {printf("[%s] -> OPERADORES RELACIONAIS\n", yytext); return DIFERENTE;}
"=" {printf("[%s] -> SIMBOLO ATRIBUICAO\n", yytext); return ATRIBUICAO;}
"--" {printf("[%s] -> OPERADORES UNARIOS\n", yytext); return DECREMENTO;}
"++" {printf("[%s] -> OPERADORES UNARIOS\n", yytext); return INCREMENTO;}
"&" {printf("[%s] -> OPERADORES UNARIOS\n", yytext); return AMPERSAND;}

")" {printf("[%s] -> SEPARADORES\n", yytext); return FECHAPARENTESES;}
"(" {printf("[%s] -> SEPARADORES\n", yytext); return ABREPARENTESES;}
"{" {printf("[%s] -> SEPARADORES\n", yytext); return ABRECHAVE;}
"}" {printf("[%s] -> SEPARADORES\n", yytext); return FECHACHAVE;}
";" {printf("[%s] -> SEPARADORES\n", yytext); return PONTOEVIRGULA;}
"," {printf("[%s] -> SEPARADORES\n", yytext); return VIRGULA;}

"&&&"("&")* {
	printf("[%s] -> INVALIDO ", yytext);
	erros++;
	printf("Linha: %d\n", linha);
}
"|||"("|")* {
	printf("[%s] -> INVALIDO ", yytext);
	erros++;
	printf("Linha: %d\n", linha);
}
"!!!"("!")* {
	printf("[%s] -> INVALIDO ", yytext);
	erros++;
	printf("Linha: %d\n", linha);
}
"==="("=")* {
	printf("[%s] -> INVALIDO ", yytext);
	erros++;
	printf("Linha: %d\n", linha);
}

"=>"|"=<"|"=!" {
	printf("[%s] -> INVALIDO ", yytext);
	erros++;
	printf("Linha: %d\n", linha);
}


\n {
        linha++;
}

. {
        printf("[%s] -> INVALIDO ", yytext);
        erros++;
        printf("Linha: %d\n", linha);
}

%%
/*int main(int argc, char **argv){
	if(argc == 2){
		yyin = fopen(argv[1], "r");
		if(yyin){
			yylex();
			printf("Total de Erros Encontrados: %d\n", erros);
        		if(erros == 0){
                		printf("\nCodigo Analisado com Sucesso!\n");
			}
		}
	}
	else{
		printf("Arquivo de entrada nao informado.\n");
	}
	return 0;
}*/
