DROP TABLE IF EXISTS public.GRUPO;

CREATE TABLE public.GRUPO (
  id SERIAL PRIMARY KEY,
  DESCRICAO varchar(255) default NULL
);

INSERT INTO public.GRUPO (id,DESCRICAO) VALUES (1,'GRUPO 1');
INSERT INTO public.GRUPO (id,DESCRICAO) VALUES (2,'GRUPO 2');
INSERT INTO public.GRUPO (id,DESCRICAO) VALUES (3,'GRUPO 3');
INSERT INTO public.GRUPO (id,DESCRICAO) VALUES (4,'GRUPO 4');
INSERT INTO public.GRUPO (id,DESCRICAO) VALUES (5,'GRUPO 5');