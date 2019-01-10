:- initialization(main).

%! ----------- Funcoes relacionadas a Bloco -----------

%! Cria Bloco Genesis
buildBlocoGenesis(0, 0, [(7,0,1000), (7,1,1000)] , "before", "hash").

%! Cria Bloco

% buildBloco(Index, TimeStamp, Transacoes ,HashAnterior, Hash).

%! Cria Bloco e verifica se o Index já existe na blockchain, se existir verifica na proxima posicao até chegar em um Index nao existente na blockchain, quando encontra constroi o bloco.
buildBlocoNaBlockchain(N, TimeStamp, Transacoes, HashAnterior, Hash):- 
buildBloco(N, _,_,_,_) -> I is N+1, 
buildBlocoNaBlockchain(I); 
buildBloco(N, TimeStamp, Transacoes, HashAnterior, Hash).

%! ----------- Funcoes relacionadas a Transacao -----------

%! Cria transacao pendente e a coloca em formato de Lista.
buildTransacaoPendente(Sender, Receiver, Valor, Transacao) :- 
Transacao = [Sender,Receiver,Valor].

%! Cria lista de transações pendentes
buildListaTransacaoPendentes(Transacao):- Transacao = [].

%! Adiciona uma nova transacao na lista de transações pendentes.
addTransacaoPendente(TransacaoPendente, TransacoesPen, [TransacoesPen|TransacaoPendente]).

%! Transfere as transacoes pendentes para a lista de transcoes feitas no bloco.
transfereTransacoesPendentes([],L1,L2).
transfereTransacoesPendentes([Head|Tail],L1,[Head|L2]) :-
  transfereTransacoesPendentes(Tail,L1,L2).

%! ----------- Funcoes relacionadas a Blockchain -----------

%! Cria uma blockchain
buildBlockchain(Cadeia) :- Cadeia = [].
%! Adiciona bloco na blockchain

addBloco(Cadeia, Bloco, [Bloco|Cadeia]).

%! Lista de transacoes pendentes previamente mineradas
transacao(T) :- T = [[1,1],[0,2],[0,3],[1,4],[1,5],[1,6]]..

transacao(Valor, X):- Valor is (X * 100).
exibir_saldo(_, [], Saldo, Saldo).

%! Faz operacoes de soma e subtracao para os saldos da pessoa 1 e 0
exibir_saldo(X, [[H1, H2] | T], Saldo, Total) :- H1 == X , transacao(Valor, H2), NSALDO is Saldo + Valor, exibir_saldo(1, T, NSALDO, Total).  
exibir_saldo(X, [[H1, H2] | T], Saldo, Total) :- H1 =\= X , transacao(Valor, H2), NSALDO is Saldo - Valor, exibir_saldo(1, T, NSALDO, Total).  

%! Menu
main :- 
  writeln("1.Enviar dinheiro (nao implementado)"),
  writeln("2.Exibir saldo"),
  writeln("3.Minerar bloco (nao implementado)"),
  writeln("4.Exibir transacoes pendentes"),
  writeln("5.Sair"),
  read_line_to_codes(user_input, Codes),
  string_to_atom(Codes, Atom),
  atom_number(Atom, Opcao),
  opcoes(Opcao).

opcoes(Opcao):-
   (
    (Opcao =:= 1 , enviar_dinheiro());
    (Opcao =:= 2, exibir_o_saldo());
    (Opcao =:= 3, minerar_bloco());
    (Opcao =:= 4, exibir_transacoes_pendentes());
   (Opcao =:= 5, break);
   (writeln("Opção inválida, digite novamente"), read(Escolha), opcoes(Escolha))
   ).

%! Exibir Saldo
exibir_o_saldo() :- 
    transacao(T),
    writeln("Digite o numero para qual pessoa voce deseja calcular o saldo. (0 para Alice, 1 para Bob)"),

    read_line_to_codes(user_input, Codes),
    string_to_atom(Codes, Atom),
    atom_number(Atom, X),

    exibir_saldo(X, T, 0, Total),
    write_ln(Total).
