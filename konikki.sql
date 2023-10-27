-- Entidad "evento"
CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL
);

-- Atributos de "evento" separados como Relaciones para la FN3
CREATE TABLE hora_evento(
    id_evento NUMBER NOT NULL REFERENCES evento(id_evento), 
    CONSTRAINT pk_hora_evento PRIMARY KEY (id_evento),
    hora_inicio TIMESTAMP NOT NULL, 
    hora_final TIMESTAMP NOT NULL
); 
CREATE TABLE fecha_evento (
    id_evento NUMBER NOT NULL REFERENCES evento(id_evento), 
    CONSTRAINT pk_hora_evento PRIMARY KEY (id_evento),
    fecha DATE NOT NULL,
    dias_consecutivos NUMBER(2) NOT NULL
);
CREATE TABLE estado_de_evento(
    id_evento NUMBER NOT NULL REFERENCES evento(id_evento), 
    CONSTRAINT pk_hora_evento PRIMARY KEY (id_evento),
    estado VARCHAR(15) NOT NULL,
    CONSTRAINT chk_estado_de_evento CHECK (estado='Finalizado' OR estado='Activo' OR estado='En desarrollo')
); 
CREATE TABLE tematica_evento(
    id_evento NUMBER NOT NULL REFERENCES evento(id_evento), 
    CONSTRAINT pk_hora_evento PRIMARY KEY (id_evento),
    Temática VARCHAR(20) NOT NULL
);

-- Relacion "evento-ubicacion"
CREATE TABLE se_lleva_a_cabo_en (
    id_evento NUMBER NOT NULL REFERENCES evento(id_evento),
    geopoint VARCHAR(50) NOT NULL REFERENCES ubicacion(geopoint),
    CONSTRAINT pk_se_lleva_a_cabo_en PRIMARY KEY (id_evento)
);

-- Relacion "evento-tienda"
CREATE TABLE trabaja_con(
    id_evento NUMBER NOT NULL REFERENCES evento(id_evento), 
    id_tienda VARCHAR(50) NOT NULL REFERENCES tienda(id_tienda), 
    tarifa_tienda NUMBER NOT NULL,
    CONSTRAINT pk_trabaja_con PRIMARY KEY (id_evento, id_tienda)
); 

-- Entidad "ubicacion"
CREATE TABLE ubicación (
    geopoint VARCHAR(50) SERIAL PRIMARY KEY,
    calle VARCHAR(50) NOT NULL
);

CREATE TABLE ciudad_ubicacion (
    geopoint VARCHAR(50) NOT NULL REFERENCES ubicacion(geopoint),
    ciudad VARCHAR(50) NOT NULL,
    CONSTRAINT pk_ciudad_ubicacion PRIMARY KEY (geopoint) 
);

-- Atributos "ubicacion"
CREATE TABLE descripcion_ubicación (
    geopoint VARCHAR(50) NOT NULL REFERENCES ubicacion(geopoint),
    aforo NUMBER NOT NULL, 
    cantidad_banos NUMBER NOT NULL, 
    tejado BOOLEAN NOT NULL,
    CONSTRAINT pk_descripcion_ubicación PRIMARY KEY (geopoint)
);

--actividad
CREATE TABLE actividad (
    id_actividad NUMBER SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
CREATE TABLE tipo_actividad(
    id_actividad NUMBER NOT NULL REFERENCES actividad(id_actividad),
    Tipo VARCHAR(50) NOT NULL
);
CREATE TABLE concurso(
    id_actividad NUMBER NOT NULL REFERENCES actividad(id_actividad),
    CONSTRAINT pk_concurso PRIMARY KEY(id_actividad)
);
CREATE TABLE taller(
    id_actividad NUMBER NOT NULL REFERENCES actividad(id_actividad),
    CONSTRAINT pk_taller PRIMARY KEY(id_actividad)
);
CREATE TABLE zona_interactiva(
    id_actividad NUMBER NOT NULL REFERENCES actividad(id_actividad),
    CONSTRAINT pk_zona_interactiva PRIMARY KEY(id_actividad)
);
CREATE TABLE evento_asociado(
    id_actividad NUMBER NOT NULL REFERENCES actividad(id_actividad),
    id_evento NUMBER NOT NULL REFERENCES evento(id_evento),
    CONSTRAINT pk_evento_asociado PRIMARY KEY(id_actividad, id_evento)
);

-- organizador
CREATE TABLE organizador(
    usuario_org VARCHAR(50) SERIAL PRIMARY KEY,
    correo VARCHAR(60) NOT NULL,
    contrasena VARCHAR(50) NOT NULL
);
CREATE TABLE administra_evento(
    id_evento NUMBER NOT NULL REFERENCES evento(id_evento),
    usuario_org VARCHAR(50) NOT NULL REFERENCES organizador(usuario_org),
    CONSTRAINT pk_administra_evento PRIMARY KEY(id_evento)
);
CREATE TABLE financiado_por(
    usuario_org VARCHAR(50) NOT NULL REFERENCES organizador(usuario_org),
    id_patrocinador VARCHAR(50) NOT NULL REFERENCES patrocinador(id_patrocinador),
    CONSTRAINT pk_financiado_por PRIMARY KEY(usuario_org, id_patrocinador)
);
CREATE TABLE puede_ver(
    usuario_org VARCHAR(50) NOT NULL REFERENCES organizador(usuario_org),
    id_producto NUMBER NOT NULL REFERENCES producto(id_producto),
    vista_privada BOOLEAN NOT NULL,
    CONSTRAINT pk_id_producto PRIMARY KEY(usuario_org, id_producto)
);
CREATE TABLE patrocinador(
    id_patrocinador NUMBER PRIMARY KEY,
    nombre VARCHAR(50)
);

--producto
CREATE TABLE producto(
    id_producto NUMBER SERIAL PRIMARY KEY,
    nombre VARCHAR(50)
);
CREATE TABLE stock_producto(
    id_producto NUMBER NOT NULL REFERENCES producto(id_producto),
    stock NUMBER,
    CONSTRAINT pk_stock_producto PRIMARY KEY(id_producto)
);
CREATE TABLE precio_producto(
    id_producto NUMBER NOT NULL REFERENCES producto(id_producto),
    precio NUMBER,
    CONSTRAINT pk_stock_producto PRIMARY KEY(id_producto)
);
CREATE TABLE etiqueta(
    id_etiqueta NUMBER PRIMARY KEY,
    nombre VARCHAR(50)
);
CREATE TABLE etiqueta_producto(
    id_producto NUMBER NOT NULL REFERENCES producto(id_producto),
    id_etiqueta NUMBER NOT NULL REFERENCES etiqueta(id_etiqueta),
    CONSTRAINT pk_stock_producto PRIMARY KEY(id_producto, id_etiqueta)
);
CREATE TABLE producto_asociado_a_tienda(
    id_producto NUMBER NOT NULL REFERENCES producto(id_producto),
    id_tienda NOT NULL REFERENCES tienda(id_tienda),
    CONSTRAINT pk_stock_producto PRIMARY KEY(id_producto)
);

-- Entidad "tienda"
CREATE TABLE tienda (
    id_tienda NUMBER SERIAL PRIMARY KEY,
    usuario_tienda VARCHAR(50),
    correo VARCHAR(60) NOT NULL, 
    contrasena VARCHAR(50) NOT NULL
);
CREATE TABLE resena_tienda(
    id_tienda NUMBER NOT NULL REFERENCES tienda(id_tienda), 
    resena VARCHAR(200) NOT NULL,
    CONSTRAINT pk_resena_tienda PRIMARY KEY (id_tienda)
);
CREATE TABLE mensaje_resena_tienda(
    id_tienda NUMBER NOT NULL REFERENCES tienda(id_tienda),
    resena VARCHAR(255),
    CONSTRAINT pk_resena_tienda PRIMARY KEY (id_tienda)
);
CREATE TABLE tienda_redacta_resena(
    id_tienda NUMBER NOT NULL REFERENCES tienda(id_tienda), 
    id_evento NUMBER NOT NULL REFERENCES evento(id_evento),
    CONSTRAINT pk_resena_tienda PRIMARY KEY (id_tienda)
);

CREATE TABLE tipo_producto(
    id_tienda VARCHAR(50) NOT NULL REFERENCES tienda(id_tienda), 
    --Mercancia (NOSE COMO HACERLO AIUDA),
    CONSTRAINT pk_resena_tienda PRIMARY KEY (id_tienda)
); --check Mercancia in (Comida, Mercaderia, Arte, Comida_Mercaderia, Comida_Arte, Mercaderia_Arte, Comida_Mercaderia_Arte); 
CREATE TABLE comida(
    id_tienda VARCHAR(50) NOT NULL REFERENCES tienda(id_tienda), 
    CONSTRAINT pk_comida PRIMARY KEY (id_tienda)
); 
CREATE TABLE mercaderia(
    id_tienda VARCHAR(50) NOT NULL REFERENCES tienda(id_tienda), 
    CONSTRAINT pk_mercaderia PRIMARY KEY (id_tienda)
); 
CREATE TABLE arte(
    id_tienda VARCHAR(50) NOT NULL REFERENCES tienda(id_tienda), 
    CONSTRAINT pk_arte PRIMARY KEY (id_tienda)
);  
CREATE TABLE comida_mercaderia(
    id_tienda VARCHAR(50) NOT NULL REFERENCES tienda(id_tienda), 
    CONSTRAINT pk_comida_mercaderia PRIMARY KEY (id_tienda)
);  
CREATE TABLE comida_arte(
    id_tienda VARCHAR(50) NOT NULL REFERENCES tienda(id_tienda), 
    CONSTRAINT pk_comida_arte PRIMARY KEY (id_tienda)
);  
CREATE TABLE mercaderia_arte(
    id_tienda VARCHAR(50) NOT NULL REFERENCES tienda(id_tienda), 
    CONSTRAINT pk_mercaderia_arte PRIMARY KEY (id_tienda)
); 
CREATE TABLE comida_mercaderia_arte(
    id_tienda VARCHAR(50) NOT NULL REFERENCES tienda(id_tienda), 
    CONSTRAINT pk_comida_mercaderia_arte PRIMARY KEY (id_tienda)
); 

-- Influencer
CREATE TABLE influencer(
    id_influencer NUMBER PRIMARY KEY,
    nombre VARCHAR(50),
    descripcion VARCHAR(300)
);
Create table especialidad(
    id_especialidad NUMBER PRIMARY KEY,
    descripcion VARCHAR(300)
);
CREATE TABLE especialidad_influencer(
    id_influencer NUMBER NOT NULL REFERENCES influencer(id_influencer),
    id_especialidad NUMBER NOT NULL REFERENCES especialidad(id_especialidad),
    CONSTRAINT pk_especialidad_influencer PRIMARY KEY (id_influencer, id_especialidad)
);

--Contrato
CREATE TABLE contrato(
    id_influencer NUMBER NOT NULL REFERENCES influencer(id_influencer),
    id_evento NUMBER NOT NULL REFERENCES evento(id_evento),
    precio NUMBER,
    CONSTRAINT pk_contrato PRIMARY KEY (id_influencer, id_evento)
);

--Asistente
CREATE TABLE asistente(
    id_asistente NUMBER PRIMARY KEY,
    Correo VARCHAR(100)
);
CREATE TABLE resena_asistente(
    id_resena_asistente NUMBER PRIMARY KEY,
    id_asistente NUMBER NOT NULL REFERENCES asistente(id_asistente)
);
CREATE TABLE mensaje_resena_asistente(
    id_resena_asistente NUMBER NOT NULL REFERENCES resena_asistente(id_resena_asistente), 
    resena VARCHAR(255)
);
CREATE TABLE asistente_redacta_resena(
    id_resena_asistente NUMBER NOT NULL REFERENCES resena_asistente(id_resena_asistente), 
    id_evento NUMBER NOT NULL REFERENCES evento(id_evento)
);

--Asistencia
CREATE TABLE asistencia(
    id_asistente NUMBER NOT NULL REFERENCES asistente(id_asistente),
    id_evento NUMBER NOT NULL REFERENCES evento(id_evento),
    CONSTRAINT pk_asistencia PRIMARY KEY (id_asistente, id_evento)  
);
