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