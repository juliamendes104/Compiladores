%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	
	extern char *yytext;
	extern int linha;
	extern int erros;
	
	int yylex(void);
	void yyerror(const char *msg);
%}

%token NUMERO
%token REAL
%token IDENTIFICADOR
%token ATRIBUICAO
%token FECHAPARENTESES ABREPARENTESES
%token ABRECHAVE FECHACHAVE
%token INT FLOAT DOUBLE
%token MAIN
%token PONTOEVIRGULA VIRGULA
%token IF ELSE
%token WHILE FOR
%token ADICAO SUBTRACAO MULTIPLICACAO DIVISAO MODULO
%token MAIOR MENOR IGUAL MAIORIGUAL MENORIGUAL DIFERENTE
%token E OU
%token PRINTF SCANF
%token INCREMENTO DECREMENTO
%token AMPERSAND

%%

funcao_principal:
	INT MAIN parenteses bloco
	| error {yyerror("Erro de sintaxe na funcao principal");
		yyclearin;
		yyerrok;}
	;
	
parenteses:
	ABREPARENTESES FECHAPARENTESES
	| error {yyclearin;
		yyerrok;}
	;
	
bloco:
	ABRECHAVE cs FECHACHAVE
	;
cs:
	c
	| c cs
	;

c:
	decl PONTOEVIRGULA
	| atri PONTOEVIRGULA
	| una PONTOEVIRGULA
	| IF ABREPARENTESES cond FECHAPARENTESES bloco else
	| WHILE ABREPARENTESES cond FECHAPARENTESES bloco
	| PRINTF ABREPARENTESES write FECHAPARENTESES PONTOEVIRGULA
	| SCANF ABREPARENTESES read FECHAPARENTESES PONTOEVIRGULA
	| FOR ABREPARENTESES atri PONTOEVIRGULA cond PONTOEVIRGULA una FECHAPARENTESES bloco
	;
	
else:
	| ELSE bloco
	;
	
decl:
	tipo lista_var
	;

tipo:
	INT
	| FLOAT
	| DOUBLE
	;
	
lista_var:
	IDENTIFICADOR VIRGULA lista_var
	| IDENTIFICADOR
	| atri VIRGULA lista_var
	| atri
	;
	
atri:
	IDENTIFICADOR ATRIBUICAO exp
	| IDENTIFICADOR ATRIBUICAO una
	;
	
exp:
	exp ADICAO termo
	| exp SUBTRACAO termo
	| termo
	;
	
termo:
	termo MULTIPLICACAO fator
	| termo DIVISAO fator
	| termo MODULO fator
	| fator
	;
	
fator:
	ABREPARENTESES exp FECHAPARENTESES
	| NUMERO
	| REAL
	| IDENTIFICADOR
	;
	
cond:
	rel E rel
	| rel OU rel
	| rel
	;
	
rel:
	exp MAIOR exp
	| exp MENOR exp
	| exp IGUAL exp
	| exp MAIORIGUAL exp
	| exp MENORIGUAL exp
	| exp DIFERENTE exp
	;
	
una:
	op IDENTIFICADOR
	| IDENTIFICADOR op
	;

op:
	INCREMENTO
	| DECREMENTO
	;
	
write:
	IDENTIFICADOR
	| IDENTIFICADOR write
	;
	
read:
	MODULO IDENTIFICADOR VIRGULA AMPERSAND IDENTIFICADOR
	;
%%

extern FILE *yyin;

void yyerror(const char *msg){
	printf("%s '%s' nao esperado. Linha: %d\n", msg, yytext, linha);
	erros++;
}

int main(int argc, char **argv){
	if(argc > 0){
		yyin = fopen(argv[1], "r");
	}
	else{
		printf("Arquivo de entrada nao informado.\n");
		exit(0);
	}
	
	do{
		yyparse();
	}while(!feof(yyin));
	
	if(erros == 0){
		printf("Analise concluida com sucesso");
	}
	return 0;
}
