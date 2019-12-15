create schema if not exists curso AUTHORIZATION postgres;
comment on schema curso is 'schema para curso de SQL';

create sequence if not exists curso.seq_cidade;
create table if not exists curso.cidade (
	id integer not null default nextval('curso.seq_cidade'),
	descricao varchar(255) not null,
	constraint cidade_pkey primary key (id)
);
comment on table curso.cidade is 'Tabela cidade do curso SQL';
comment on column curso.cidade.id IS 'Identificador único da cidade';

create sequence if not exists curso.seq_cliente;
create table if not exists public.cliente (
	id integer not null default nextval('curso.seq_cliente'),
	nome varchar(255),
	cidade int4,
	email varchar(255),
	nome_fantasia varchar(255),
	constraint cliente_pkey primary key (id),
	constraint fk_cliente_cidade foreign key (cidade) references cidade(id)
);

alter table cliente add column documento varchar14);
alter table cliente alter column documento type varchar(20);
alter table curso.cliente rename column documento TO cpf_cnpj;
alter table cliente drop column cpf_cnpj;
alter table public.cliente rename to clientes;

create sequence curso.seq_cidade
	increment by 1
	minvalue 1
	maxvalue 9223372036854775807
	start 1
	cache 1
	no cycle;

alter table curso.teste drop constraint fk_teste_cidade;	

alter table public.pedido add constraint chk_valor_pedido check (valor > 0.00);

alter table curso.cliente add constraint uk_cliente_cpf_cnpj unique (cpf_cnpj);

create type endereco as (logradouro varchar(200), numero varchar(20));

alter table curso.cliente add column endereco_entrega endereco;

create type public.endereco as (
	logradouro varchar(200),
	numero varchar(20)
);
alter type public.endereco add atribute 

create type public.status_pedido as enum('ABERTO','CANCELADO','FATURADO','FECHADO','PENDENTE');
alter type public.status_pedido rename value 'ABERTO' TO 'AB';

alter table public.pedido rename column status TO status_old;
alter type public.endereco alter attribute numero TYPE varchar(10) cascade;
alter type public.endereco drop attribute numero;
DROP TYPE IF EXISTS endereco cascade;

alter type <name_type> rename atribute <nome_atributo> to <novo_nome_atributo>;
alter type <name_type> rename to <new_name>;
alter type <name_type> set schena <novo_schema>;
alter type <name_type> add value [ if not exists ] <novo_valor_enum> [ { BEFORE | AFTER } <valor_enum> ];
alter type <name_type> rename value <valor_enum> to <novo_valor_emum>;
alter type <name_type> add atribute <attribute_name> >data_type>;
alter type <name_type> DROP ATTRIBUTE [ IF EXISTS ] attribute_name [ CASCADE | RESTRICT ];


create domain numero_postal as varchar(10)
check(
   value ~ '^\d{5}-\d{4}$'
);