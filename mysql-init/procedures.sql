delimiter //

create procedure registrar_compra(
    in p_id_usuario int,
    in p_id_ingresso int,
    in p_quantidade int
)

begin
    declare v_id_compra int;


-- Criar regisro na tabela 'compra'
insert into compra (data_compra, fk_id_usuario)
values (now(), p_id_usuario);

-- Obter o ID da compra recém-criada
set v_id_compra = last_insert_id();

-- Registrar os ingressos comprados
insert into ingresso_compra (fk_id_compra, fk_id_ingresso, quantidade)
    values (v_id_compra, p_id_ingresso, p_quantidade);

end; //

delimiter ;

-----------------------------------------------------------------------------------------

delimiter //

create procedure total_ingressos_usuario(
    in p_id_usuario int,
    out p_total_ingressos int
)
begin
    -- Inicializar o valor de saída
    set p_total_ingressos = 0;

    -- Consultar e somar todos os ingressos comprados pelo usuário
    select coalesce(sum(ic.quantidade), 0)
    into p_total_ingressos
    from ingresso_compra ic
    join compra c on ic.fk_id_compra = c.id_compra
    where c.fk_id_usuario = p_id_usuario;
end;
//

delimiter ;

----------------------------------------------------------------------------------------------

show procedure status where db = 'vio_leonardo';
set @total = 0;
call total_ingressos_usuario (2, @total);

----------------------------------------------------------------------------------------------

delimiter //

create procedure registrar_presenca(
    in p_id_compra int,
    out p_id_evento int
)
begin
    -- Registrar presença
    insert into presenca (data_hora_checkin, fk_id_evento, fk_id_compra)
    values (now(), p_id_evento, p_id_compra);
end; //

delimiter ;

----------------------------------------------------------------------------------------------

-- Tabela para testar a clausula
create table log_evento (
    id_log int AUTO_INCREMENT PRIMARY KEY,
    mensagem varchar(255),
    data_log datetime default current_timestamp
);

delimiter $$
create function registrar_log_evento(texto  varchar(255))
returns varchar(50)
not deterministic
modifies sql data
begin
    insert into log_evento(mensagem)
    values (texto);

    return 'Log inserido com sucesso';
end; $$

delimiter ;

-- Visualiza o estado da variavel de controle para permissões de criação de funções
show variables like 'log_bin_trust_function_creators';

-- Atualiza o estado da variavel de controle
set global log_bin_trust_function_creators = 1;

select registrar_log_evento('teste') as log;

-----------------------------------------------------------------------------------------------

C