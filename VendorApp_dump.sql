--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg22.04+1)
-- Dumped by pg_dump version 15.1 (Ubuntu 15.1-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: vendor; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA vendor;


ALTER SCHEMA vendor OWNER TO postgres;

--
-- Name: product_create_dto; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.product_create_dto AS (
	id integer,
	name character varying,
	code character varying,
	price integer,
	number integer
);


ALTER TYPE public.product_create_dto OWNER TO postgres;

--
-- Name: change_product_code(integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.change_product_code(productid integer, productcode character varying, userid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin

    if not exists(select * from owners where id = userid) then
        raise exception 'userid doesnt exist with id %',userid;
    end if;

    if not exists(select * from products where id = productid) then
        raise exception 'productid doesnt exist with id %',productid;
    end if;

    update products
    set code = productCode
    where id = productId;
    return true;

end
$$;


ALTER FUNCTION public.change_product_code(productid integer, productcode character varying, userid integer) OWNER TO postgres;

--
-- Name: change_product_id(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.change_product_id(productid integer, newid integer, userid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin
    if not exists(select * from owners where id = userid) then
        raise exception 'userid doesnt exist with id %',userid;
    end if;

    if not exists(select * from products where id = productid) then
        raise exception 'productid doesnt exist with id %',productid;
    end if;

    update products
    set id = newId
    where id = productId;
    return true;
end
$$;


ALTER FUNCTION public.change_product_id(productid integer, newid integer, userid integer) OWNER TO postgres;

--
-- Name: change_product_name(integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.change_product_name(productid integer, productname character varying, userid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin

    if not exists(select * from owners where id = userid) then
        raise exception 'userid doesnt exist with id %',userid;
    end if;

    if not exists(select * from products where id = productid) then
        raise exception 'productid doesnt exist with id %',productid;
    end if;

    update products
    set name = productName
    where id = productId;
    return true;

end
$$;


ALTER FUNCTION public.change_product_name(productid integer, productname character varying, userid integer) OWNER TO postgres;

--
-- Name: change_product_number(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.change_product_number(productid integer, productnumber integer, userid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin

    if not exists(select * from owners where id = userid) then
        raise exception 'userid doesnt exist with id %',userid;
    end if;

    if not exists(select * from products where id = productid) then
        raise exception 'productid doesnt exist with id %',productid;
    end if;

    update products
    set number = ProductNumber
    where id = productId;
    return true;

end
$$;


ALTER FUNCTION public.change_product_number(productid integer, productnumber integer, userid integer) OWNER TO postgres;

--
-- Name: change_product_prize(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.change_product_prize(productid integer, productprize integer, userid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin

    if not exists(select * from owners where id = userid) then
        raise exception 'userid doesnt exist with id %',userid;
    end if;

    if not exists(select * from products where id = productid) then
        raise exception 'productid doesnt exist with id %',productid;
    end if;

    update products
    set price = productPrize
    where id = productId;
    return true;
end
$$;


ALTER FUNCTION public.change_product_prize(productid integer, productprize integer, userid integer) OWNER TO postgres;

--
-- Name: delete_product(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_product(userid bigint, productid bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin

    if not exists(select * from owners where id = userid) then
        raise exception 'Subject doesnt exist with id %',userid;
    end if;

    if not exists(select * from products where id = productid) then
        raise exception 'Subject doesnt exist with id %',productid;
    end if;

    delete from products where id=productid;
    return true;
end
$$;


ALTER FUNCTION public.delete_product(userid bigint, productid bigint) OWNER TO postgres;

--
-- Name: getproduct(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getproduct(productname character varying, userid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin
    if not exists(select * from products where name = ProductName) then
        raise exception 'userid doesnt exist with id %',userid;
    end if;

    if (select number from products where name = ProductName) > 0 and
       (select money from users where users.id = userId) > (select price from products where name = ProductName) then
        update products set number =number - 1 where name = ProductName;
        update users set money = money - (select price from products where name = ProductName) where users.id = userId;
    else
        raise 'You can not get';
    end if;

    return true;
end
$$;


ALTER FUNCTION public.getproduct(productname character varying, userid integer) OWNER TO postgres;

--
-- Name: json_to_product_create_dto(json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.json_to_product_create_dto(datajson json) RETURNS public.product_create_dto
    LANGUAGE plpgsql
    AS $$
declare
    dto product_create_dto;
begin
    dto.id := dataJson ->> 'id';
    dto.name := dataJson ->> 'name';
    dto.code := dataJson ->> 'code';
    dto.price := dataJson ->> 'price';
    dto.number := dataJson ->> 'number';
    return dto;
end
$$;


ALTER FUNCTION public.json_to_product_create_dto(datajson json) OWNER TO postgres;

--
-- Name: product_create(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.product_create(dataparam text, userid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
    newId    int4;
    dataJson json;
    dto      product_create_dto;
begin

    if dataparam isnull or dataparam = '{}'::text then
        raise exception 'Data param can not be null';
    end if;

    dataJson := dataparam::json;
    dto := json_to_product_create_dto(dataJson);

    if dto.name is null then
        raise exception 'name is invalid';
    end if;
    if dto.code is null then
        raise exception 'code is invalid';
    end if;
    if dto.price = 0 then
        raise exception 'price is invalid';
    end if;
    if dto.number = 0 then
        raise exception 'number is invalid';
    end if;

    if userid not in (select id from owners) then
        raise exception 'You are not owner';
    end if;


    insert into products (name, code,price,number)
    values (dto.name,
            dto.code,
            dto.price,
            dto.number)
    returning number into newId;
    return newId;
end
$$;


ALTER FUNCTION public.product_create(dataparam text, userid integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: owners_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.owners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.owners_id_seq OWNER TO postgres;

--
-- Name: owners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.owners_id_seq OWNED BY public.owners.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    code character varying(50) NOT NULL,
    price integer NOT NULL,
    number integer
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    money integer
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: owners id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners ALTER COLUMN id SET DEFAULT nextval('public.owners_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: owners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.owners (id, name) FROM stdin;
1	Muhammad
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, code, price, number) FROM stdin;
3	Coca-cola	COLA	12000	10
4	Pepsi	PEP	12000	15
5	olma	OL	10000	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, money) FROM stdin;
1	valavala	80000
\.


--
-- Name: owners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.owners_id_seq', 1, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 4, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: owners owners_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_name_key UNIQUE (name);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (id);


--
-- Name: products products_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_code_key UNIQUE (code);


--
-- Name: products products_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_name_key UNIQUE (name);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: users users_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_name_key UNIQUE (name);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

