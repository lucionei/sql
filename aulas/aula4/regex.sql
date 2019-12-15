select *
from cliente
where email ~*'^[a-z]{1,}\.[a-z]{1,}\@[a-z]{1,}\.org$';