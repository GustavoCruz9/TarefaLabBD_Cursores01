create database TarefaLabBD_Cursores01
go
use TarefaLabBD_Cursores01
go
create table envio (
	CPF varchar(20),
	NR_LINHA_ARQUIV int,
	CD_FILIAL int,
	DT_ENVIO datetime,
	NR_DDD int,
	NR_TELEFONE varchar(10),
	NR_RAMAL varchar(10),
	DT_PROCESSAMENT datetime,
	NM_ENDERECO varchar(200),
	NR_ENDERECO int,
	NM_COMPLEMENTO varchar(50),
	NM_BAIRRO varchar(100),
	NR_CEP varchar(10),
	NM_CIDADE varchar(100),
	NM_UF varchar(2),
)
go
create table endereço(
	CPF varchar(20),
	CEP varchar(10),
	PORTA int,
	ENDEREÇO varchar(200),
	COMPLEMENTO varchar(100),
	BAIRRO varchar(100),
	CIDADE varchar(100),
	UF Varchar(2)
)

go

create procedure sp_insereenvio
as
	declare @cpf as int
	declare @cont1 as int
	declare @cont2 as int
	declare @conttotal as int
	set @cpf = 11111
	set @cont1 = 1
	set @cont2 = 1
	set @conttotal = 1
	while @cont1 <= @cont2 and @cont2 < = 100
	begin
	insert into envio (CPF, NR_LINHA_ARQUIV, DT_ENVIO)
	values (cast(@cpf as varchar(20)), @cont1,GETDATE())
	insert into endereço (CPF,PORTA,ENDEREÇO)
	values (@cpf,@conttotal,CAST(@cont2 as varchar(3))+'Rua '+CAST(@conttotal as varchar(5)))
	set @cont1 = @cont1 + 1
	set @conttotal = @conttotal + 1
	if @cont1 > = @cont2
	begin
	set @cont1 = 1
	set @cont2 = @cont2 + 1
	set @cpf = @cpf + 1
	end
end

exec sp_insereenvio

select * from envio order by CPF,NR_LINHA_ARQUIV asc
select * from endereço order by CPF asc

create procedure sp_MoverDadosEnderecoParaEnvio
as
    declare @CPF varchar(20),
			@CEP varchar(10),
			@PORTA int,
			@END varchar(200),
			@COMPLEMENTO varchar(100),
			@BAIRRO varchar(100),
			@CIDADE varchar(100),
			@UF varchar(2),
			@NR_LINHA_ARQUIV int

    declare c cursor for
		select CPF, CEP, PORTA, ENDEREÇO, COMPLEMENTO, BAIRRO, CIDADE, UF
		FROM endereço

    open c

    fetch next from c into @CPF, @CEP, @PORTA, @END, @COMPLEMENTO, @BAIRRO, @CIDADE, @UF

    while @@FETCH_STATUS = 0
    begin
            update envio
            set NM_ENDERECO = @END,
                NR_ENDERECO = @PORTA,
                NM_COMPLEMENTO = @COMPLEMENTO,
                NM_BAIRRO = @BAIRRO,
                NR_CEP = @CEP,
                NM_CIDADE = @CIDADE,
                NM_UF = @UF
           where CPF = @CPF and NR_LINHA_ARQUIV = @NR_LINHA_ARQUIV

        fetch next from c into @CPF, @CEP, @PORTA, @END, @COMPLEMENTO, @BAIRRO, @CIDADE, @UF
    end

    close c
    deallocate c


exec sp_MoverDadosEnderecoParaEnvio

select * from envio order by CPF,NR_LINHA_ARQUIV asc
