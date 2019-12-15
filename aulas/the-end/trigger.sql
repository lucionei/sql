CREATE OR REPLACE FUNCTION public.dbf_atualiza_estoque()
RETURNS trigger
AS $$
    begin
        IF (TG_OP = 'INSERT') then
        	update public.produto 
        	set estoque = (estoque + old.quantidade) - new.quantidade
        	where produto.id = new.produto;
            RETURN NEW;
        ELSIF (TG_OP = 'UPDATE') THEN
        	update public.produto 
        	set estoque = (estoque + OLD.quantidade) - NEW.quantidade
        	where produto.id = NEW.produto;
            RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
        	update public.produto 
        	set estoque = estoque - old.quantidade
        	where produto.id = old.produto;
            RETURN OLD;
        END IF;
    end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgiud_estoque
AFTER INSERT OR UPDATE OR DELETE ON public.pedido_item
FOR EACH ROW
EXECUTE PROCEDURE public.dbf_atualiza_estoque();

CREATE OR REPLACE FUNCTION public.dbf_atualiza_valor_pedido()
RETURNS trigger
AS $$
    begin
        IF (TG_OP = 'INSERT') or (TG_OP = 'UPDATE') then
        	update public.pedido 
        	set valor = (select sum((quantidade * valor_unitario)-((quantidade * valor_unitario) * (perc_desconto / 100)))
        				   from pedido_item
        				   where pedido_item.pedido = new.pedido)
        	where pedido.id = new.pedido;
            RETURN NEW;
        ELSIF (TG_OP = 'DELETE') THEN
        	update public.pedido 
        	set valor = (select sum((quantidade * valor_unitario)-((quantidade * valor_unitario) * (perc_desconto / 100)))
        				   from pedido_item
        				   where pedido_item.pedido = old.pedido)
        	where pedido.id = old.pedido;			  
            RETURN OLD;
        END IF;
    end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgiud_atualiza_pedido
AFTER INSERT OR UPDATE OR DELETE ON public.pedido_item
FOR EACH ROW
EXECUTE PROCEDURE public.dbf_atualiza_valor_pedido();