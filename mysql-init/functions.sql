-- Criação de function
delimiter $$
create function calcula_idade(datanascimento date)
returns int
deterministic
contains sql
begin
    declare idade int;
    set idade = timestampdiff(year, datanascimento, curdate());
    return idade;
end; $$
delimiter ;

-- Verifica se a função especificada foi criada
SHOW CREATE FUNCTION calcula_idade;

SELECT name, calcula_idade(data_nascimento) AS idade FROM usuario;



delimiter $$
create function status_sistema()
returns varchar(50)
no sql
begin
    return 'Sistema operando normalmente';
end; $$
delimiter ;



-- Execução da query
select status_sistema();



delimiter $$
create function total_compras_usuario(id_usuario int)
returns int
reads sql data
begin
    declare total int;
    select count(*) into total
    from compra
    where id_usuario = compra.fk_id_usuario;

    return total;
end; $$
delimiter ;

select total_compras_usuario(3) as "Total de compras";

select routine_name from
information_schema.routines
     where routine_type = 'FUNCTION'
       and routine_schema = 'vio_leonardo';

--Maior idade
delimiter $$

create function is_maior_idade(data_nascimento date)
returns boolean
not deterministic
contains sql
begin
    declare idade int;

    -- Utilizando a função já criada
    set idade = calcula_idade(data_nascimento);
    return idade >= 18;
end; $$

delimiter ;

select is_maior_idade("2008-05-11"); as "É maior de idade?"

--categorizar usuario por faixa etária
delimiter $$

create function faixa_etaria(data_nascimento date)
returns varchar(20)
not deterministic
contains sql
begin
    declare idade int;

    --cálculo da idade com a função já criada
    DELIMITER $$

CREATE FUNCTION classificar_idade(data_nascimento DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE idade INT;
    
    -- Calcular a idade
    SET idade = TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE());

    -- Classificação de idade
    IF idade < 18 THEN
        RETURN 'menor de idade';
    ELSEIF idade < 60 THEN
        RETURN 'adulto';
    ELSE
        RETURN 'idoso';
    END IF;
END $$

DELIMITER ;


-- agrupar clientes por faixa etária
select classificar_idade(data_nascimento) as faixa, count(*) as quantidade from usuario
group by faixa;

-- identificar uma faixa etária especifica
select name from usuario
    where classificar_idade(data_nascimento) = "adulto";

-- calcular a média de idade de usuário
delimiter $$
create function media_idade()
    returns decimal(5, 2)
    not deterministic
    reads sql data
    begin
        declare media decimal(5, 2);

        -- cálculo da média das idades
        select avg(timestampdiff(year, data_nascimento, 
        curdate())) into media from usuario;

        return ifnull(media, 0);
    end; $$

    select media_idade() as media;

    -- Selcionar idade especifica
    select "A média de idades dos clientes é maior que 30" as resultado where media_idade() > 30;

    -- Exercicio direccionado
    -- Calculodo total gasto por um usuario
DELIMITER $$

CREATE FUNCTION calcula_total_gasto(pid_usuario INT)
RETURNS DECIMAL(10, 2)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(10, 2);

    -- Calculando o total gasto
    SELECT SUM(i.preco * ic.quantidade) INTO total
    FROM compra c
    JOIN ingresso_compra ic ON c.id_compra = ic.fk_id_compra
    JOIN ingresso i ON i.id_ingresso = ic.fk_id_ingresso
    WHERE c.fk_id_usuario = pid_usuario;

    -- Retorna 0 se o total for nulo
    RETURN IFNULL(total, 0);
END $$

DELIMITER ;

select calcula_total_gasto(3);

    -- Buscar a faixa etária de um usuário
    delimiter $$
    create function buscar_faixa_etaria_usuario(pid int)
    returns varchar(20)
    not deterministic
    reads sql data
    begin
        declare nascimento date;
        declare faixa varchar(20);

        select data_nascimento into nascimento
        from usuario
        where id_usuario = pid;

        set faixa = faixa_etaria(nascimento);

        return faixa;
end; $$
delimiter ;

-- ATIVIDADE
DELIMITER $$

CREATE FUNCTION total_ingressos_vendidos(pid_evento INT)
RETURNS INT
READS SQL DATA
NOT DETERMINISTIC
BEGIN
    DECLARE total_vendidos INT;

    SELECT IFNULL(SUM(ic.quantidade), 0) INTO total_vendidos
    FROM ingresso_compra ic
    JOIN ingresso i ON ic.fk_id_ingresso = i.id_ingresso
    WHERE i.fk_id_evento = pid_evento;

    RETURN total_vendidos;
END $$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION renda_total_evento(pid_evento INT)
RETURNS DECIMAL(10, 2)
READS SQL DATA
NOT DETERMINISTIC 
BEGIN
    DECLARE renda_total DECIMAL(10, 2);

    SELECT IFNULL(SUM(i.preco * ic.quantidade), 0.00) INTO renda_total
    FROM ingresso_compra ic
    JOIN ingresso i ON ic.fk_id_ingresso = i.id_ingresso
    WHERE i.fk_id_evento = pid_evento;

    RETURN renda_total;
END $$

DELIMITER ;






