CREATE TABLE IF NOT EXISTS public."Usuarios"
(
    "IdUsuarios" bigint NOT NULL,
    "Nombre(s)" text NOT NULL,
    "APaterno" text NOT NULL,
    "AMaterno" text NOT NULL,
    "FechaCrecacion" date NOT NULL,
    "UltimoLogin" date NOT NULL,
    "Contraseña" text NOT NULL,
    "IdTipo" bigint NOT NULL,
    "IdCompañia" bigint NOT NULL
);

CREATE TABLE IF NOT EXISTS public."TipoUsuario"
(
    "IdTipo" bigint NOT NULL,
    "TipoUsuario" char NOT NULL,
    PRIMARY KEY ("IdTipo")
);

CREATE TABLE IF NOT EXISTS public."Compañia"
(
    "IdCompañia" bigint NOT NULL,
    "NombreComp" text NOT NULL,
    "CorreoComp" text NOT NULL,
    "TelefonoComp" text NOT NULL,
    PRIMARY KEY ("IdCompañia")
);

CREATE TABLE IF NOT EXISTS public."PersonasFisicas"
(
    "IdPersonaF" bigint NOT NULL,
    "Nombre(s)" text NOT NULL,
    "ApellidoPat" text NOT NULL,
    "ApellidoMat" text NOT NULL,
    "Genero" text NOT NULL,
    "FechaNacimiento" date NOT NULL,
    "LugarNacimiento" text NOT NULL,
    "Nacionalidad" text NOT NULL,
    "Profesion/Ocupacion" text NOT NULL,
    "IdDomicilio" bigint NOT NULL,
    "CorreoPFisica" text NOT NULL,
    "IdDocumentos" bigint NOT NULL,
    PRIMARY KEY ("IdPersonaF")
);

CREATE TABLE IF NOT EXISTS public."Domicilio"
(
    "IdDomicilio" bigint NOT NULL,
    "Calle" text NOT NULL,
    "NumExterior" bigint NOT NULL,
    "NumInterior" bigint,
    "CodigoPostal" bigint NOT NULL,
    "Colonia" text NOT NULL,
    "Ciudad" text NOT NULL,
    "Estado" text NOT NULL,
    "Pais" text NOT NULL,
    PRIMARY KEY ("IdDomicilio")
);

CREATE TABLE IF NOT EXISTS public."DocumentosPFisicos"
(
    "IdDocumentos" bigint NOT NULL,
    "IdentificacionOficial" char NOT NULL,
    "CURP" text,
    "RFC" text,
    "NumIdFiscal" text,
    "NumTarjetaMigratoria" text,
    PRIMARY KEY ("IdDocumentos")
);

CREATE TABLE IF NOT EXISTS public."PersonaMoral"
(
    "IdPMoral" bigint NOT NULL,
    "Denominacion" text NOT NULL,
    "DomSocial" text NOT NULL,
    "TipoSociedad" text NOT NULL,
    "CapitalVariable" char,
    "AdmiteInversion" char NOT NULL,
    "IdCapSocial" bigint NOT NULL,
    "IdFormasAdmi" bigint NOT NULL,
    "IdApoderados" bigint NOT NULL,
    "IdDomLegal" bigint NOT NULL,
    "IdDomAdmi" bigint NOT NULL,
    "NumIdFiscal" text NOT NULL,
    "RFC" text,
    "NumRegPatronal" text,
    "NumEmpleados" bigint,
    "NumRegNacInvExt" text,
    "IdDocs" bigint NOT NULL,
    PRIMARY KEY ("IdPMoral")
);

CREATE TABLE IF NOT EXISTS public."CapitalSocial"
(
    "IdCapSocial" bigint NOT NULL,
    "Fijo" char,
    "ClaseFijo" text,
    "SerieFija" text,
    "Variable" char,
    "ClaseVari" text,
    "SerieVari" text,
    PRIMARY KEY ("IdCapSocial")
);

CREATE TABLE IF NOT EXISTS public."FormaAdmin"
(
    "IdFormasAdmi" bigint NOT NULL,
    "ConsejoAdmin" text NOT NULL,
    "Miembros" text NOT NULL,
    "ConsejoGerentes" text NOT NULL,
    "GerenteGeneral" text NOT NULL,
    "AdministradorUnico" text NOT NULL,
    PRIMARY KEY ("IdFormasAdmi")
);

CREATE TABLE IF NOT EXISTS public."Apoderados"
(
    "IdApoderados" bigint NOT NULL,
    "GeneralPara" text,
    "GActosAdmi" text,
    "GActosCambia" text,
    "GActosDominio" text,
    "GPleitosCobra" text,
    "Especial" text,
    "EActosAdmi" text,
    "EActosCambio" text,
    "EActosDomi" text,
    "EPleitosCobra" text,
    PRIMARY KEY ("IdApoderados")
);

CREATE TABLE IF NOT EXISTS public."DomicilioLegal"
(
    "IdDomLegal" bigint NOT NULL,
    "Calle" text NOT NULL,
    "CodigoPostal" text NOT NULL,
    "NumExt" text NOT NULL,
    "NumInt" text,
    "Colonia" text NOT NULL,
    "Ciudad" text NOT NULL,
    "Estado" text NOT NULL,
    "Pais" text NOT NULL,
    PRIMARY KEY ("IdDomLegal")
);

CREATE TABLE IF NOT EXISTS public."DomicilioOperativo"
(
    "IdDomAdmi" bigint NOT NULL,
    "Calle" text NOT NULL,
    "CodigoPostal" text NOT NULL,
    "NumExt" text NOT NULL,
    "NumInt" text,
    "Colonia" text NOT NULL,
    "Ciudad" text NOT NULL,
    "Estado" text NOT NULL,
    "Pais" text NOT NULL,
    PRIMARY KEY ("IdDomAdmi")
);

CREATE TABLE IF NOT EXISTS public."DocumentosPMoral"
(
    "IdDocs" bigint NOT NULL,
    "ActaConsti" char NOT NULL,
    "LibrosSociales" char NOT NULL,
    "DocsFePublica" char NOT NULL,
    "CompDomicilio" char NOT NULL,
    "CedulaFiscal" char NOT NULL,
    "RegPresServEsp" char NOT NULL,
    "RegistroPatronal" char,
    "PermisosDOpe" char,
    "RegNacInvExtranjera" char,
    "RegistroINM" char,
    "Otros" text,
    PRIMARY KEY ("IdDocs")
);

ALTER TABLE IF EXISTS public."PersonasFisicas"
    ADD CONSTRAINT "IdDomicilio" FOREIGN KEY ("IdDomicilio")
    REFERENCES public."Domicilio" ("IdDomicilio");

ALTER TABLE IF EXISTS public."PersonasFisicas"
    ADD CONSTRAINT "IdDocumentos" FOREIGN KEY ("IdDocumentos")
    REFERENCES public."DocumentosPFisicos" ("IdDocumentos");

ALTER TABLE IF EXISTS public."PersonaMoral"
    ADD CONSTRAINT "IdFormasAdmi" FOREIGN KEY ("IdFormasAdmi")
    REFERENCES public."FormaAdmin" ("IdFormasAdmi");

ALTER TABLE IF EXISTS public."PersonaMoral"
    ADD CONSTRAINT "IdCapSocial" FOREIGN KEY ("IdCapSocial")
    REFERENCES public."CapitalSocial" ("IdCapSocial");

ALTER TABLE IF EXISTS public."PersonaMoral"
    ADD CONSTRAINT "IdApoderados" FOREIGN KEY ("IdApoderados")
    REFERENCES public."Apoderados" ("IdApoderados");

ALTER TABLE IF EXISTS public."PersonaMoral"
    ADD CONSTRAINT "IdDomLegal" FOREIGN KEY ("IdDomLegal")
    REFERENCES public."DomicilioLegal" ("IdDomLegal");

ALTER TABLE IF EXISTS public."PersonaMoral"
    ADD CONSTRAINT "IdDomAdmi" FOREIGN KEY ("IdDomAdmi")
    REFERENCES public."DomicilioOperativo" ("IdDomAdmi");

ALTER TABLE IF EXISTS public."PersonaMoral"
    ADD CONSTRAINT "IdDocs" FOREIGN KEY ("IdDocs")
    REFERENCES public."DocumentosPMoral" ("IdDocs");

ALTER TABLE IF EXISTS public."Usuarios"
    ADD CONSTRAINT "IdCompañia" FOREIGN KEY ("IdCompañia")
    REFERENCES public."Compañia" ("IdCompañia");

ALTER TABLE IF EXISTS public."Usuarios"
    ADD CONSTRAINT "IdTipo" FOREIGN KEY ("IdTipo")
    REFERENCES public."TipoUsuario" ("IdTipo");