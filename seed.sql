-- Tipos de usuario
INSERT INTO public."TipoUsuario" ("IdTipo", "TipoUsuario") VALUES
(1, 'A'), -- Admin
(2, 'U'); -- Usuario normal

-- Compañías
INSERT INTO public."Compañia" ("IdCompañia", "NombreComp", "CorreoComp", "TelefonoComp") VALUES
(1, 'Decla S.A.', 'info@decla.mx', '555-555-5555');

-- Usuario administrador
INSERT INTO public."Usuarios"
("IdUsuarios", "Nombre(s)", "APaterno", "AMaterno", "FechaCrecacion", "UltimoLogin", "Contraseña", "IdTipo", "IdCompañia")
VALUES
(1, 'Admin', 'System', 'Root', CURRENT_DATE, CURRENT_DATE, 'admin', 1, 1);

-- Otro usuario normal (opcional)
INSERT INTO public."Usuarios"
("IdUsuarios", "Nombre(s)", "APaterno", "AMaterno", "FechaCrecacion", "UltimoLogin", "Contraseña", "IdTipo", "IdCompañia")
VALUES
(2, 'Johann', 'Vega', 'Gonzalez', CURRENT_DATE, CURRENT_DATE, 'user123', 2, 1);

-- Documentos de prueba (Persona Física)
INSERT INTO public."DocumentosPFisicos" ("IdDocumentos", "IdentificacionOficial", "CURP", "RFC", "NumIdFiscal", "NumTarjetaMigratoria") VALUES
(1, 'I', 'CUPR000000HDFRRL00', 'VGGJ800101XX0', 'FIS123', NULL);

-- Domicilio de prueba
INSERT INTO public."Domicilio" ("IdDomicilio", "Calle", "NumExterior", "NumInterior", "CodigoPostal", "Colonia", "Ciudad", "Estado", "Pais") VALUES
(1, 'Av. Principal', 123, NULL, 12345, 'Centro', 'CDMX', 'CDMX', 'México');

-- Persona física vinculada
INSERT INTO public."PersonasFisicas"
("IdPersonaF", "Nombre(s)", "ApellidoPat", "ApellidoMat", "Genero", "FechaNacimiento", "LugarNacimiento", "Nacionalidad", "Profesion/Ocupacion", "IdDomicilio", "CorreoPFisica", "IdDocumentos")
VALUES
(1, 'Carlos', 'Pérez', 'Ramírez', 'M', '1990-05-15', 'CDMX', 'Mexicana', 'Ingeniero', 1, 'carlos.perez@example.com', 1);

-- Documentos de persona moral
INSERT INTO public."DocumentosPMoral" ("IdDocs", "ActaConsti", "LibrosSociales", "DocsFePublica", "CompDomicilio", "CedulaFiscal", "RegPresServEsp") VALUES
(1, 'Y', 'Y', 'Y', 'Y', 'Y', 'N');

-- Capital social de ejemplo
INSERT INTO public."CapitalSocial" ("IdCapSocial", "Fijo", "ClaseFijo", "SerieFija", "Variable", "ClaseVari", "SerieVari") VALUES
(1, 'Y', 'Ordinaria', 'A', 'N', NULL, NULL);

-- Forma de administración de ejemplo
INSERT INTO public."FormaAdmin" ("IdFormasAdmi", "ConsejoAdmin", "Miembros", "ConsejoGerentes", "GerenteGeneral", "AdministradorUnico") VALUES
(1, 'Consejo Directivo', '3', 'Sí', 'Juan Pérez', 'No');

-- Apoderados de ejemplo
INSERT INTO public."Apoderados" ("IdApoderados", "GeneralPara", "GActosAdmi", "GActosCambia", "GActosDominio", "GPleitosCobra") VALUES
(1, 'Sí', 'Sí', 'No', 'No', 'Sí');

-- Domicilio legal y operativo de ejemplo
INSERT INTO public."DomicilioLegal" ("IdDomLegal", "Calle", "CodigoPostal", "NumExt", "Colonia", "Ciudad", "Estado", "Pais") VALUES
(1, 'Calle Legal', '06000', '10', 'Centro', 'CDMX', 'CDMX', 'México');

INSERT INTO public."DomicilioOperativo" ("IdDomAdmi", "Calle", "CodigoPostal", "NumExt", "Colonia", "Ciudad", "Estado", "Pais") VALUES
(1, 'Calle Operativa', '06100', '20', 'Roma', 'CDMX', 'CDMX', 'México');

-- Persona moral de ejemplo
INSERT INTO public."PersonaMoral"
("IdPMoral", "Denominacion", "DomSocial", "TipoSociedad", "CapitalVariable", "AdmiteInversion", "IdCapSocial", "IdFormasAdmi", "IdApoderados", "IdDomLegal", "IdDomAdmi", "NumIdFiscal", "IdDocs")
VALUES
(1, 'Empresa XYZ', 'CDMX', 'S.A. de C.V.', 'Y', 'N', '1', 1, 1, 1, 1, 'MOR123', 1);
