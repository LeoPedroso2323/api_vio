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

----------------------------------------------------------------------------------------------

delimiter $$
create function status_sistema()
returns varchar(50)
no sql
begin
    return 'Sistema operando normalmente';
end; $$
delimiter ;

----------------------------------------------------------------------------------------------

-- Execução da query
select status_sistema();

----------------------------------------------------------------------------------------------

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
