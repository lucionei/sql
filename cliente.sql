DROP TABLE IF EXISTS public.CLIENTE;

CREATE TABLE public.CLIENTE (
  ID SERIAL PRIMARY KEY,
  NOME varchar(255) default NULL,
  CIDADE integer NULL,
  EMAIL varchar(255) default NULL
);

INSERT INTO public.CLIENTE (ID,NOME,CIDADE,EMAIL) VALUES (1,'Jack',7,'orci.lacus@velit.org'),(2,'Idona',3,'In.condimentum.Donec@tempus.com'),(3,'Myra',4,'ligula@sedfacilisis.co.uk'),(4,'Gretchen',10,'neque.Nullam@magnaNam.org'),(5,'Melyssa',10,'nibh.Aliquam@parturientmontesnascetur.co.uk'),(6,'Hu',8,'mattis@mifelisadipiscing.ca'),(7,'Debra',2,'semper.egestas.urna@non.net'),(8,'Leo',9,'ut.erat.Sed@vulputatevelit.ca'),(9,'Hilel',7,'Nulla.semper.tellus@et.net'),(10,'Linus',7,'erat.in@Nullasemper.net');

COPY (
    select *
    from public.CLIENTE
    order by id
) TO 'C:\exemplo.txt' WITH NULL AS 'null';

COPY public.CLIENTE FROM 'c:\exemplo.txt' using delimiters ';';
