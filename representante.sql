drop table if exists representante;

create table representante (
  id integer NOT NULL PRIMARY KEY,
  nome varchar(30),
  id_supervisor integer
);

insert into representante(id, nome, id_supervisor)
values(1,'João Silva', null);
insert into representante(id, nome, id_supervisor)
values(2, 'Vanessa Santos', 1);
insert into representante(id, nome, id_supervisor)
values(3, 'Felipe Castro', 1);
insert into representante(id, nome, id_supervisor)
values(4, 'Aline Pereira', 2);
insert into representante(id, nome, id_supervisor)
values(5, 'Caio Silva', 2);
insert into representante(id, nome, id_supervisor)
values(6, 'Taís Naves', 3);