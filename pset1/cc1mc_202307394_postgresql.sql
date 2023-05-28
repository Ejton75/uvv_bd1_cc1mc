-- Apagar usuario, BD e esquema se existir--
DROP SCHEMA IF EXISTS lojas CASCADE;
DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS ton;

---------------------------------------------
--criar usuario, usa-lo e criar BD--
CREATE USER ton WITH CREATEDB CREATEROLE PASSWORD '123';
SET ROLE ton;
CREATE DATABASE uvv
    OWNER = ton
    TEMPLATE = template0
    ENCODING = UTF8
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    ALLOW_CONNECTIONS = true;

-----------------------------------------------------
-- automatizar senha ****risco de segurança**** mas nao achei outra opção--
\setenv PGPASSWORD 123

--------------------------------------------------
-- conectar com meu usuario no banco de cados UVV--
\c uvv ton;

------------------------------------------------
-- criar esquema --
CREATE SCHEMA lojas 
AUTHORIZATION ton;

--------------------------------------------------------
--conectar ao esquema--
SET SEARCH_PATH TO lojas, "$ton", public;

------------------------------------------------------------
-- criação e comentarios da tabela produtos--

CREATE TABLE produtos (
                p_produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT p_produto_id PRIMARY KEY (p_produto_id)
);
COMMENT ON TABLE produtos IS 'Informações gerais dos produtos.';
COMMENT ON COLUMN produtos.p_produto_id IS 'PK da tabela e numero de identificação do produto.';
COMMENT ON COLUMN produtos.nome IS 'Nome do produto.';
COMMENT ON COLUMN produtos.preco_unitario IS 'Preço de uma unidade do produto.';
COMMENT ON COLUMN produtos.detalhes IS 'Detalhes do produto.';
COMMENT ON COLUMN produtos.imagem IS 'Imagem do produto.';
COMMENT ON COLUMN produtos.imagem_arquivo IS 'endereço do arquivo de imagem.';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS 'Registro de data e hoarairio da ultima atualização da imagem do produto.';

---------------------------------------------------------
-- criação e comentarios da tabela lojas--

CREATE TABLE lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA NOT NULL,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT loja_id PRIMARY KEY (loja_id)
);
COMMENT ON TABLE lojas IS 'Infoirmações gerais das lojas';
COMMENT ON COLUMN lojas.loja_id IS 'PK da tabela e numero de identificação da loja.';
COMMENT ON COLUMN lojas.nome IS 'Nome da loja.';
COMMENT ON COLUMN lojas.endereco_web IS 'Endereço do site da loja.';
COMMENT ON COLUMN lojas.endereco_fisico IS 'Endereço fisico da loja.';
COMMENT ON COLUMN lojas.latitude IS 'Latitude da coordenada geografica da loja';
COMMENT ON COLUMN lojas.longitude IS 'Longitude da coordenada geografica da loja.';
COMMENT ON COLUMN lojas.logo IS 'Logo da loja.';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao IS 'Data e horario da ultima atualização do logo da loja.';

-------------------------------------------------------------------
-- criação e comentarios da tabela estoques--

CREATE TABLE estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                p_produto_id NUMERIC(38) NOT NULL,
                CONSTRAINT estoque_id PRIMARY KEY (estoque_id)
);
COMMENT ON TABLE estoques IS 'Informações gerais sobre o estoque das lojas.';
COMMENT ON COLUMN estoques.estoque_id IS 'PK da tabela e numero de identificação do estoque.';
COMMENT ON COLUMN estoques.loja_id IS 'Fk da tabela lojas e numero de identificação da loja.';
COMMENT ON COLUMN estoques.p_produto_id IS 'FK da tabela produtos e numero de identificação do produto.';

--------------------------------------------------------------------
-- criação e comentarios da tabela clientes--

CREATE TABLE clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT cliente_id PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE clientes IS 'informações cadastrais dos clientes';
COMMENT ON COLUMN clientes.cliente_id IS 'PK da tabela e identificação do cliente.';
COMMENT ON COLUMN clientes.email IS 'Email do cliente.';
COMMENT ON COLUMN clientes.nome IS 'Nome do cliente.';
COMMENT ON COLUMN clientes.telefone1 IS 'Telefone 1 do cliente.';
COMMENT ON COLUMN clientes.telefone2 IS 'Telefone 2 do cliente.';
COMMENT ON COLUMN clientes.telefone3 IS 'Telefone 3 do cliente.';

-----------------------------------------------------------------------------------------
-- criação e comentarios da tabela envios--

CREATE TABLE envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                e_status VARCHAR(15) NOT NULL,
                CONSTRAINT envio_id PRIMARY KEY (envio_id)
);
COMMENT ON TABLE envios IS 'Informações associadas ao envio de mercadorias.';
COMMENT ON COLUMN envios.envio_id IS 'PK e numero de identeificação do envio de mercadorias.';
COMMENT ON COLUMN envios.loja_id IS 'FK da tabela lojas e numero de identeificação da loja.';
COMMENT ON COLUMN envios.cliente_id IS 'FK da tabela clientes e numero de identificaçao do cliente.';
COMMENT ON COLUMN envios.endereco_entrega IS 'Endereço de entrega para o envio.';
COMMENT ON COLUMN envios.e_status IS 'Status do envio.';

--------------------------------------------------------------------------------------------------------
-- criação e comentarios da tabela pedidos--

CREATE TABLE pedidos (
                p_pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                p_status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT p_pedido_id PRIMARY KEY (p_pedido_id)
);
COMMENT ON TABLE pedidos IS 'Informações sobre situção dos pedidos.';
COMMENT ON COLUMN pedidos.p_pedido_id IS 'PK da tabela e número identificador do pedido.';
COMMENT ON COLUMN pedidos.data_hora IS 'Data e hora de realização dos pedidos.';
COMMENT ON COLUMN pedidos.cliente_id IS 'FK da tabela clientes e identificação do cliente.';
COMMENT ON COLUMN pedidos.p_status IS 'Status do pedido';
COMMENT ON COLUMN pedidos.loja_id IS 'FK da tabela lojas e numero de identificação da loja.';

----------------------------------------------------------------------------------------
-- criação e comentarios da tabela produtos_itens--

CREATE TABLE produtos_itens (
                pi_pedido_id NUMERIC(38) NOT NULL,
                pi_produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38),
                CONSTRAINT pi_pedido_id PRIMARY KEY (pi_pedido_id, pi_produto_id)
);
COMMENT ON TABLE produtos_itens IS 'Tabela de relacionamento entre pedidos e produtos, indica informações gerais sobre quais produtos estao em quais pedidos.';
COMMENT ON COLUMN produtos_itens.pi_pedido_id IS 'PK da tabela e número identificador do pedido.';
COMMENT ON COLUMN produtos_itens.pi_produto_id IS 'PK da tabela e numero de identificação do produto.';
COMMENT ON COLUMN produtos_itens.preco_unitario IS 'Preço da unidade de um produto.';
COMMENT ON COLUMN produtos_itens.quantidade IS 'Quantidade de um produto em um pedido.';
COMMENT ON COLUMN produtos_itens.envio_id IS 'PK e numero de identeificação do envio de mercadorias.';

-------------------------------------------------------------------------------------------------------------------
-- criação de constraints da tabela estoques--

ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (p_produto_id)
REFERENCES lojas.produtos (p_produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

------------------------------------------------------------
-- criação de constraints da tabela produtos_itens--

ALTER TABLE lojas.produtos_itens ADD CONSTRAINT pedidos_produtos_itens_fk
FOREIGN KEY (pi_pedido_id)
REFERENCES lojas.pedidos (p_pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.produtos_itens ADD CONSTRAINT produtos_produtos_itens_fk
FOREIGN KEY (pi_produto_id)
REFERENCES lojas.produtos (p_produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.produtos_itens ADD CONSTRAINT envios_produtos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.produtos_itens ADD CONSTRAINT produtos_itens_valores_positivos
CHECK(preco_unitario > 0 OR quantidade > 0 );

--------------------------------------------------------------------
-- criação de constraints da tabela pedidos--

ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT pedidos_status_constraint 
CHECK(
    p_status = 'CANCELADO' 
    or p_status = 'COMPLETO' 
    or p_status = 'ABERTO' 
    or p_status = 'PAGO' 
    or p_status = 'REEMBOLSADO'
    or p_status ='ENVIADO'
    );
-----------------------------------------------------------------------
-- criação de constraints da tabela envios--

ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT envios_status_constraint
CHECK(
    e_status = 'CRIADO'
    or e_status ='ENVIADO'
    or e_status = 'TRANSITO'
    or e_status ='ENTREGUE'
    );
    
--------------------------------------------------------------------
-- criação de constraints da tabela lojas--


ALTER TABLE lojas.lojas ADD CONSTRAINT endereços_presentes
CHECK(
    lojas.endereco_fisico = '%'
    OR lojas.endereco_web = '%'
);




