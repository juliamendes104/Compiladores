%{
	#include<stdio.h>
	int linha = 1, erros = 0;
%}

%option noyywrap

DIGITO[0-9]
ID[A-Za-z][A-Za-z0-9]*
ESPACO[\t\r" "]

%%

{ESPACO}+
"/*"[^*]*"*/"
"//"[^\n]*

{DIGITO}+{ID}+ {
	printf("[%s] -> IDENTIFICADOR INVALIDO ", yytext);
	erros++;
	printf("Linha: %d\n", linha);
}
{DIGITO}+ {printf("[%s] -> INTEIRO\n", yytext);}
{DIGITO}+"."{DIGITO}+ {printf("[%s] -> REAL\n", yytext);}
"."{DIGITO}+ {
	printf("[%s] -> INVALIDO ", yytext);
	erros++;
	printf("Linha: %d\n", linha);
}

{ID} {printf("[%s] -> IDENTIFICADOR\n", yytext);}


"+"|"-"|"*"|"/"|"%" {printf("[%s] -> OPERADORES ARITMETICOS\n", yytext);}
"&&"|"||"|"!" {printf("[%s] -> OPERADORES LOGICOS\n", yytext);}
"=="|">"|"<"|">="|"<="|"!=" {printf("[%s] -> OPERADORES RELACIONAIS\n", yytext);}
"=" {printf("[%s] -> SIMBOLO ATRIBUICAO\n", yytext);}
"--"|"++"|"&" {printf("[%s] -> OPERADORES UNARIOS\n", yytext);}
\"|\)|\(|\{|\}|\;|\, {printf("[%s] -> SEPARADORES\n", yytext);}
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
int main(int argc, char **argv){
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
}
