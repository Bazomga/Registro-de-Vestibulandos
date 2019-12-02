Program Trabalho2 ;

Type Reg_Vestib = Record
  Cod_Vest : integer;
  Nome_Vest: string[60];
  Cod_Cur: integer;
  Stat_Vest: Integer;
End;

Reg_Curso = Record
  Cod_Curso : Integer;
  Nome_Curso : string[20];
  Vagas_Curso : integer;
  Inscritos_Curso: integer;
  Stat_Curso: integer;
End;

var
arqcur: File of Reg_Curso;
arqvest: File of Reg_Vestib;
c,c_aux: Reg_Curso;
v,v_aux: Reg_Vestib;
flag:char;

procedure Abrir_Arquivos;
Begin
  Assign (arqcur,'curso.dta');
  {$I-}
  reset(arqcur);
  {$I+}
  If (IOResult<>0) then
  rewrite(arqcur);
  Assign (arqvest,'vestib.dta');
  {$I-}
  reset(arqvest);
  {$I+}
  If (IOResult<>0) then
  rewrite(arqvest);
End;
//Procedure para abrir arquivo

procedure Bordas;
var border:integer;
Begin
  for border := 2 to 79 do
  begin
    gotoxy(border,1);write(#205);
    gotoxy(border,24);write(#205);
  end;
  for border:=2 to 23 do
  begin
    gotoxy(1,border);write(#186);
    gotoxy(80,border);write(#186);
  end;
  gotoxy(1,1);write(#201);
  gotoxy(80,1);write(#187);
  gotoxy(1,24);write(#200);
  gotoxy(80,24);write(#188);
End;
//Procedure para as bordas

function Pesq_Codigo(Cod:Integer;Decisao:Char):Integer;
Var aux,y,x:integer;
Begin
  aux:=-1;
  if ((decisao='c') or (decisao='C')) then
  Begin
    seek(arqcur,0);
    y:=filesize(arqcur);
    for x:=0 to y do
    Begin
      read(arqcur,c_aux);
      If (c_aux.Cod_Curso=Cod) then
      aux:=x;
    End;
  End
  else
  Begin
    seek(arqvest,0);
    y:=filesize(arqvest);
    for x:=0 to y do
    Begin
      read(arqvest,v_aux);
      If (v_aux.Cod_Vest=Cod) then
      aux:=x;
    End;
  End;
  Pesq_Codigo:=aux;
End;
//Função Pesquisa de Codigo

Function Verif_Ativo(Numero:Integer;Decisao:Char):Integer;
var aux,y,x:Integer;
Begin
  Verif_Ativo:=0;
  if (Decisao='c') then
  Begin
    seek(arqcur,0);
    y:=filesize(arqcur);
    for x:=0 to y do
    Begin
      read(arqcur,c_aux);
      If (c_aux.Stat_Curso=0) then
      Verif_Ativo:=1;
    End;
  End
  else
  Begin
    seek(arqvest,0);
    y:=filesize(arqvest);
    for x:=0 to y do
    Begin
      read(arqvest,v_aux);
      If (v_aux.Cod_Cur=Numero) then
      Verif_Ativo:=1;
    End;
  End;
End;

procedure Cad_Curso;
var aux:integer;
Begin
  clrscr;
  textcolor(lightcyan);
  bordas;
  textcolor(yellow);
  gotoxy(29,2);write('CADASTRAMENTO DE CURSO');
  gotoxy(5,4);write('Codigo do curso:');
  gotoxy(5,5);write('Nome do curso:');
  gotoxy(5,6);write('Vagas do curso:');
  repeat
    aux:=-1;
    gotoxy(22,4);read(c.Cod_Curso);
    aux:=Pesq_Codigo(c.Cod_Curso,'c');
    If (aux>=0) then
    Begin
      gotoxy(26,4);textcolor(lightred);
      write('Codigo ja existente, informe outro!');
      textcolor(yellow);
      readkey;
      gotoxy(22,4);write('                                                     ');
    End;
  until (aux<0);
  gotoxy(22,5);read(c.Nome_Curso);
  gotoxy(22,6);read(c.Vagas_Curso);
  c.Inscritos_Curso:=0;
  c.Stat_Curso:=1;
  Seek(arqcur,Filesize(arqcur));
  write(arqcur,c);
  gotoxy(26,12);textcolor(lightgreen);write('CURSO CADASTRADO COM SUCESSO');
  readkey;
End;
//Cadastramento de Curso

procedure Cad_Vest;
var aux,verificador:integer;
Begin
  clrscr;
  textcolor(lightcyan);
  bordas;
  textcolor(yellow);
  gotoxy(29,2);write('CADASTRAMENTO DE VESTIBULANDO');
  gotoxy(5,4);write('Codigo do Vestibulando:');
  gotoxy(5,5);write('Nome do Vestibulando:');
  gotoxy(5,6);write('Codigo do Curso:');
  repeat
    aux:=-1;
    gotoxy(29,4);read(v.Cod_Vest);
    aux:=Pesq_Codigo(v.Cod_Vest,'v');
    If (aux>=0) then
    Begin
      gotoxy(35,4);textcolor(lightred);
      write('Codigo ja existente, informe outro!');
      textcolor(yellow);
      readkey;
      gotoxy(29,4);write('                                           ');
    End;
  until (aux<0);
  gotoxy(29,5);read(v.Nome_Vest);
  repeat
    aux:=-1;
    Verificador:=0;
    gotoxy(29,6);read(v.Cod_Cur);
    aux:=Pesq_Codigo(v.Cod_Cur,'c');
    verificador:=Verif_Ativo(0,'c');
    if (aux<0) or (Verificador=1) then
    Begin
      gotoxy(35,6);textcolor(lightred);
      write('Codigo de curso invalido ou curso inativo!');
      textcolor(yellow);
      readkey;
      gotoxy(29,6);write('                                                 ');
    End;
  until (aux>=0);
  Seek(arqcur,aux);
  read(arqcur,c);
  c.Inscritos_Curso:=C.Inscritos_Curso+1;
  Seek(arqcur,aux);
  write(arqcur,c);
  v.Stat_Vest:=1;
  Seek(arqvest,Filesize(arqvest));
  write(arqvest,v);
  gotoxy(25,12);textcolor(lightgreen);write('VESTIBULANDO CADASTRADO COM SUCESSO');
  readkey;
End;
//Cadastramento de Vestibulando

Procedure Relat_Curso;
var x,y,ypos:integer;
Begin
  clrscr;
  Bordas;
  gotoxy(30,2);textcolor(lightmagenta);write('|RELATORIO DE CURSOS|');
  gotoxy(3,3);write('Cod.');
  gotoxy(8,3);write('Nome');
  gotoxy(30,3);write('Insc/Vaga');
  gotoxy(40,3);write('Status');
  y:=((filesize(arqcur))-1);
  seek(arqcur,0);
  for x:=0 to y do
  Begin
    textcolor(white);
    ypos:=x+4;
    read(arqcur,c);
    gotoxy(3,ypos);write(c.Cod_Curso);
    gotoxy(8,ypos);write(c.Nome_Curso);
    gotoxy(30,ypos);write(c.Inscritos_Curso,'/',c.Vagas_Curso);
    if c.Stat_Curso=1 then
    Begin
      gotoxy(40,ypos);textcolor(lightgreen);write('Ativo');
    End
    else
    Begin
      gotoxy(40,ypos);textcolor(lightred);write('Inativo');
    End;
  End;
  readkey;
End;
//Relatorio de Cursos

Procedure Relat_Vest;
var x,y,ypos,aux:integer;
Begin
  clrscr;
  Bordas;
  gotoxy(26,2);textcolor(lightmagenta);write('|RELATORIO DE VESTIBULANDO|');
  gotoxy(3,3);write('Cod.');
  gotoxy(8,3);write('Nome');
  gotoxy(38,3);write('Status');
  gotoxy(48,3);write('Curso');
  textcolor(white);
  y:=((filesize(arqvest))-1);
  seek(arqvest,0);
  for x:=0 to y do
  Begin
    ypos:=x+4;
    read(arqvest,v);
    gotoxy(3,ypos);write(v.Cod_Vest);
    gotoxy(8,ypos);write(v.Nome_Vest);
    if v.Stat_Vest=1 then
    Begin
      gotoxy(38,ypos);textcolor(lightgreen);write('Ativo');
    End
    else
    Begin
      gotoxy(38,ypos);textcolor(lightred);write('Inativo');
    End;
    //Pesquisa o nome do curso
    aux:=Pesq_Codigo(v.Cod_Cur,'c');
    seek(arqcur,aux);
    read(arqcur,c);
    gotoxy(48,ypos);textcolor(white);write(c.Nome_Curso);
  End;
  readkey;
End;

Procedure Alt_Curso;
var ncur,aux,altflag,verif:integer;
altmenu,confirmacao:char;
Begin
  clrscr;
  Bordas;
  gotoxy(32,2);textcolor(magenta);write('ALTERANDO: CURSO');
  gotoxy(3,4);write('Digite o codigo do curso que deseja alterar:');
  repeat
    altflag:=0;
    textcolor(white);
    gotoxy(3,5);read(ncur);
    aux:=Pesq_Codigo(ncur,'c');
    if (aux<0) then
    Begin
      gotoxy(10,5);textcolor(lightred);write('Codigo não encontrado!');
      readkey;
      gotoxy(3,5);write('                                       ');
    End;
  until (aux>=0);
  seek(arqcur,aux);
  read(arqcur,c);
  repeat
    clrscr;
    Bordas;
    gotoxy(32,2);textcolor(magenta);write('ALTERANDO: CURSO');
    textcolor(lightmagenta);
    gotoxy(5,4);write('Nome:');
    gotoxy(5,5);write('Vagas:');
    gotoxy(5,6);write('Status:');
    textcolor(white);
    gotoxy(13,4);write(c.Nome_Curso);
    gotoxy(13,5);write(c.Vagas_Curso);
    gotoxy(13,6);
    if (c.Stat_Curso=1) then
    Begin
      textcolor(lightgreen);write('Ativo');
    End
    else
    Begin
      textcolor(lightred);write('Inativo');
    End;
    textcolor(magenta);
    gotoxy(5,10);write('Qual informaçao deseja modificar?');
    gotoxy(5,11);write('1- Nome do curso');
    gotoxy(5,12);write('2- Numero de vagas');
    gotoxy(5,13);write('3- Alterar status');
    gotoxy(5,14);write('4- Finalizar alteraçoes');
    gotoxy(5,15);write('5- Descartar alteraçoes e voltar ao menu principal');
    gotoxy(5,16);write('>');
    altmenu:=readkey;
    textcolor(yellow);
    case altmenu of
      '1':Begin
        gotoxy(5,18);write('Digite um novo nome e aperte [ENTER]');
        gotoxy(5,19);read(c.Nome_Curso);
        gotoxy(5,20);textcolor(lightgreen);write('NOME ALTERADO! Pressione qualquer botao para continaur.');
        readkey;
      End;
      '2':Begin
        gotoxy(5,18);write('Informe o novo numero de vagas e aperte [ENTER]');
        gotoxy(5,19);read(c.Vagas_Curso);
        gotoxy(5,20);textcolor(lightgreen);write('N. DE VAGAS ALTERADA! Pressione qualquer botao para continuar.');
        readkey;
      End;
      '3':Begin
        if (c.Stat_Curso=1) then
        Begin
          verif:=0;
          verif:=Verif_Ativo(c.Cod_Curso,'v');
          If (verif=0) then
          Begin
            c.Stat_Curso:=0;
            gotoxy(5,18);textcolor(lightgreen);write('STATUS ALTERADO! Pressione qualquer botao para continuar.');
          End
          else
          Begin
            gotoxy(5,18);textcolor(lightred);write('O curso ja esta vinculado a um vestibulando, nao foi possivel alterar.');
          End;
        End
        else
        Begin
          c.Stat_Curso:=1;
          gotoxy(5,18);textcolor(lightgreen);write('STATUS ALTERADO! Pressione qualquer botao para continuar.');
        End;
        readkey;
      End;
      '4':Begin
        gotoxy(5,18);textcolor(lightred);write('DESEJA REESCREVER AS INFORMAÇÕES? s/n');
        gotoxy(5,19);
        confirmacao:=readkey;
        if (confirmacao='s') or (confirmacao='S') then
        Begin
          altflag:=1;
          seek(arqcur,aux);
          write(arqcur,c);
          gotoxy(5,20);textcolor(lightgreen);write('Dados foram alterados com sucesso!');
          readkey;
        End;
      End;
      '5':Begin
        gotoxy(5,18);textcolor(lightred);write('DESEJA DESCARTAR AS ALTERAÇOES? s/n');
        gotoxy(5,19);
        confirmacao:=readkey;
        if (confirmacao='s') or (confirmacao='S') then
        altflag:=1;
      End;
    End;
  until (altflag=1);
End;

Procedure Alt_Vest;
var nvest,aux,auxp,altflag,excur,verificador:integer;
altmenu,confirmacao:char;
Begin
  clrscr;
  Bordas;
  gotoxy(28,2);textcolor(magenta);write('ALTERANDO: VESTIBULANDO');
  gotoxy(3,4);write('Digite o codigo do vestibulando que deseja alterar:');
  repeat
    altflag:=0;
    textcolor(white);
    gotoxy(3,5);read(nvest);
    aux:=Pesq_Codigo(nvest,'v');
    if (aux<0) then
    Begin
      gotoxy(10,5);textcolor(lightred);write('Codigo não encontrado!');
      readkey;
      gotoxy(3,5);write('                                   ');
    End;
  until (aux>=0);
  seek(arqvest,aux);
  read(arqvest,v);
  repeat
    clrscr;
    Bordas;
    gotoxy(28,2);textcolor(magenta);write('ALTERANDO: CURSO');
    textcolor(lightmagenta);
    gotoxy(5,4);write('Nome:');
    gotoxy(5,5);write('Curso:');
    gotoxy(5,6);write('Status:');
    textcolor(white);
    gotoxy(13,4);write(v.Nome_Vest);
    auxp:=Pesq_Codigo(v.Cod_Cur,'c');
    seek(arqcur,auxp);
    read(arqcur,c);
    gotoxy(13,5);write(c.Nome_Curso);
    gotoxy(13,6);
    if (v.Stat_Vest=1) then
    Begin
      textcolor(lightgreen);write('Ativo');
    End
    else
    Begin
      textcolor(lightred);write('Inativo');
    End;
    textcolor(magenta);
    gotoxy(5,10);write('Qual informaçao deseja modificar?');
    gotoxy(5,11);write('1- Nome do vestibulando');
    gotoxy(5,12);write('2- Curso');
    gotoxy(5,13);write('3- Alterar status');
    gotoxy(5,14);write('4- Finalizar alteraçoes');
    gotoxy(5,15);write('5- Descartar alteraçoes e voltar ao menu principal');
    gotoxy(5,16);write('>');
    altmenu:=readkey;
    textcolor(yellow);
    case altmenu of
      '1':Begin
        gotoxy(5,18);write('Digite um novo nome e aperte [ENTER]');
        gotoxy(5,19);read(v.Nome_Vest);
        gotoxy(5,20);textcolor(lightgreen);write('NOME ALTERADO! Pressione qualquer botao para continaur.');
        readkey;
      End;
      '2':Begin
        gotoxy(5,18);write('Informe o codigo do novo curso e aperte [ENTER]');
        repeat
          auxp:=-1;
          excur:=auxp;
          verificador:=0;
          gotoxy(5,19);read(v.Cod_Cur);
          auxp:=Pesq_Codigo(v.Cod_Cur,'c');
          verificador:=Verif_Ativo(0,'c');
          if (auxp<0) or (Verificador=1) then
          Begin
            gotoxy(10,19);textcolor(lightred);
            write('Codigo de curso invalido ou curso inativo!');
            textcolor(yellow);
            readkey;
            gotoxy(5,19);write('                                            ');
          End;
        until (aux>=0);
        Seek(arqcur,excur);
        read(arqcur,c);
        c.Inscritos_Curso:=C.Inscritos_Curso-1;
        Seek(arqcur,excur);
        write(arqcur,c);
        Seek(arqcur,auxp);
        read(arqcur,c);
        c.Inscritos_Curso:=C.Inscritos_Curso+1;
        Seek(arqcur,auxp);
        write(arqcur,c);
        gotoxy(5,20);textcolor(lightgreen);write('CURSO ALTERADO! Pressione qualquer botao para continuar.');
        readkey;
      End;
      '3':Begin
        if (v.Stat_Vest=1) then
        Begin
          v.Stat_Vest:=0;
          Seek(arqcur,auxp);
          read(arqcur,c);
          c.Inscritos_Curso:=C.Inscritos_Curso-1;
          Seek(arqcur,auxp);
          write(arqcur,c);
        End
        else
        Begin
          v.Stat_Vest:=1;
          Seek(arqcur,auxp);
          read(arqcur,c);
          c.Inscritos_Curso:=C.Inscritos_Curso+1;
          Seek(arqcur,auxp);
          write(arqcur,c);
        End;
        gotoxy(5,18);textcolor(lightgreen);write('STATUS ALTERADO! Pressione qualquer botao para continuar.');
        readkey;
      End;
      '4':Begin
        gotoxy(5,18);textcolor(lightred);write('DESEJA REESCREVER AS INFORMAÇÕES? s/n');
        gotoxy(5,19);
        confirmacao:=readkey;
        if (confirmacao='s') or (confirmacao='S') then
        Begin
          altflag:=1;
          seek(arqvest,aux);
          write(arqvest,v);
          gotoxy(5,20);textcolor(lightgreen);write('Dados foram alterados com sucesso!');
          readkey;
        End;
      End;
      '5':Begin
        gotoxy(5,18);textcolor(lightred);write('DESEJA DESCARTAR AS ALTERAÇOES? s/n');
        gotoxy(5,19);
        confirmacao:=readkey;
        if (confirmacao='s') or (confirmacao='S') then
        altflag:=1;
      End;
    End;
  until (altflag=1);
End;

Procedure Concorrencia;
var x,y,ypos:integer;
conc:real;
Begin
  clrscr;
  Bordas;
  gotoxy(33,2);textcolor(lightmagenta);write('|CONCORRENCIA|');
  gotoxy(3,3);write('Curso');
  gotoxy(25,3);write('Concorrencia');
  gotoxy(40,3);write('Inscritos');
  gotoxy(52,3);write('Vagas');
  textcolor(white);
  y:=((filesize(arqcur))-1);
  seek(arqcur,0);
  for x:=0 to y do
  Begin
    ypos:=x+4;
    read(arqcur,c);
    gotoxy(3,ypos);write(c.Nome_Curso);
    if (c.Inscritos_Curso>0) then
    conc:=(c.Vagas_Curso/c.Inscritos_Curso)
    else
    conc:=c.Vagas_Curso;
    gotoxy(25,ypos);write(conc:0:2);
    gotoxy(40,ypos);write(c.Inscritos_Curso);
    gotoxy(52,ypos);write(c.Vagas_Curso);
  End;
  readkey;
End;

Begin
  Abrir_Arquivos;
  Repeat
    clrscr;
    textcolor(lightcyan);
    Bordas;
    gotoxy(25,2);write('Qual operaçao deseja realizar?');
    textcolor(yellow);
    gotoxy(5,4);write('CADASTRAMENTO E ALTERACAO');
    gotoxy(5,6);write('1 - Cadastrar curso');
    gotoxy(5,7);write('2 - Cadastrar vestibulando');
    gotoxy(5,8);write('3 - Alterar dados do curso');
    gotoxy(5,9);write('4 - Alterar dados do vestibulando');
    textcolor(white);
    gotoxy(5,13);write('RELATORIOS');
    gotoxy(5,15);write('5 - Relatorio de cursos');
    gotoxy(5,16);write('6 - Relatorio de vestibulando');
    gotoxy(5,17);write('7 - Relatorio de concorrencia/vestibulando');
    textcolor(lightred);
    gotoxy(5,20);write('8 - Finalizar');
    gotoxy(5,23);write('>');
    flag:=readkey;
    case flag of
      '1':Begin
        Cad_Curso;
      End;
      '2':Begin
        Cad_vest;
      End;
      '3':Begin
        Alt_Curso;
      End;
      '4':Begin
        Alt_Vest;
      End;
      '5':Begin
        Relat_Curso;
      End;
      '6':Begin
        Relat_Vest;
      End;
      '7':Begin
        Concorrencia;
      End;
    End;
  Until (flag='8');
  Close(arqcur);
  Close(arqvest);
  clrscr;
  textcolor(lightred);
  Bordas;
  gotoxy(32,12);write('Fim de Execuçao');
  Readkey;
End.