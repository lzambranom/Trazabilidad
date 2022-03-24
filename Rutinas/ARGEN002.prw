#include "PROTHEUS.ch"

#DEFINE PRODUC	2
#DEFINE DESCRI	3
#DEFINE CANTID	4
#DEFINE UM		5
#DEFINE LOCALD	6
#DEFINE LOCALI	7
#DEFINE LOTE	8
#DEFINE DTVALI	9

#DEFINE PRODARCH 2
#DEFINE DESCARCH 3
#DEFINE CANTARCH 4        
#DEFINE DEPOARCH 6
#DEFINE UBIARCH 7
#DEFINE LOTEARCH 8

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FECHA:	03/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Carga masiva de items.
**************************************************************************************************************************************************
PROGRAMA: 	ARGEN002	|	MODIFICACIï¿½N	|	FECHA:	19/05/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: 1 - Se corrigio un error de SmartClient al seleccionar desde la opcion de Documentos el documento de Movimientos Internos.
2 - Se modifico el filtro sobre los campos Lote y Fecha de Vencimiento, estos campos se dejan en blanco si el Lote comienza con 'AUTO', el Deposito
es 'MT', la opciï¿½n es por Documentos y el Documento es Factura de Compras.
3 - Se agregaron los campos Cliente/Proveedor y Loja, en la selecciï¿½n de Documentos.
4 - Al elegir un registro desde la consulta standard, se completan los campos Serie, Proveedor/Cliente (Segun la especie) y la Loja. NOTA: los 
campos Serie, Proveedor/Cliente y Loja se autocompletan sobre el registro seleccionado en la consulta standard, si solo se ingresa el numero de 
documento (sin la consulta standard) muestra la Serie, Proveedor/Cliente y Loja del primer registro que encuentra.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function ARGEN002(nOpc)
Local aArea := GetArea()

Private cFile := PADL("",6," ")
Private aItems	:= {}
Private aGenera	:= {} 
Private aColsTRB:= {}
Private aHeadTRB:= {}
Private aSizes	:= {}

Private cSD2Espe:= "RTS|RFN|RFB|RCD"
Private cSD1Espe:= ""//"RTE|RCN|RFD|NF "
Private cSD3Espe:= "SD3"
Private cGenera	:= ""

Private cDoc	:= PADL("",6," ")
Private cDepos	:= PADL("",TamSX3 ( "D1_LOCAL" ) [ 1 ]," ")
Private cUbi	:= PADL("",TamSX3 ( "D1_LOCALIZ" ) [ 1 ]," ")
Private cEspecie:= PADL("",TamSX3 ( "D1_ESPECIE" ) [ 1 ]," ")
Private cSerie	:= PADL("",6," ")
Private cCliente:= PADL("",TamSX3 ( "D1_FORNECE" ) [ 1 ]," ")
Private cLoja	:= PADL("",TamSX3 ( "D1_LOJA" ) [ 1 ]," ")
Private dFecAux := CTOD("  /  /  ")
Private cEspAux := ""
Private cTrf	:= PADL("",TamSX3( "D3_DOC" )[1]," ")

Private oDlg		:= Nil

Private nOpcEnchoi	:= nOpc

//msgalert('Advertencia !!! los productos BLOQUEADOS no serï¿½n procesados' + CHR(13) + 'Por favor revisar que no existan productos bloqueados a procesar')

	Do Case
	   Case nOpc == 1
    	    u_ARGEN02D()
	   Case nOpc == 2
    	    u_ARGEN02U()
	   Case nOpc == 3
    	    u_ARGEN02A()
	EndCase

RestArea(aArea)

Return

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGEN02A	|	FECHA:	03/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Importo desde un archivo de texto con extension CSV.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function ARGEN02A()
Private cPerg	:= "ARGEN02A"

	AjustaSX1(cPerg)

	If Pergunte( cPerg ,.T.)
		cFile := Alltrim(MV_PAR03)
		cDepos	:= MV_PAR01	// Deposito destino
		cUbi	:= MV_PAR02	// Ubicacion destino
		// Proceso Archivo
		u_AGEN02PA()
	EndIf
Pergunte("MTA260",.F.)
Return

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGEN02D	|	FECHA:	03/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Importo desde un Documento existente.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/
User Function ARGEN02D()
Local lOk	:= .F.
Local nI	:= 0
Local lSigo	:= .T.

	lSigo := ValidoaCols()

	IF lSigo
		aGenera  := {	"Tras. Alistamiento" ,;
						"Tras. Despacho"	 ,;
						"Tras. Pedido venta" ,;
						"Mov.Transferencia" 	}
						/*
						"Remito Beneficiamiento",;
						"Remito Compras",;
						"Remito Compras Devoluciï¿½n",;
						"Remito Ventas Devoluciï¿½n",;
						"Factura Compras",;
						*/
						//"Movimientos Internos"}

		lOk := ArmoPantalla()

		IF lOk
			u_AGEN02DD(cDoc, cDepos, cUbi)
		EndIF
	EndIF

Return

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGEN02U	|	FECHA:	03/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Importo desde un Deposito y Ubicacion.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function ARGEN02U()
Local lSigo	:= .T.
Private cPerg := "ARGEN02U"

	lSigo := ValidoaCols()

	IF lSigo
		AjustaSX1(cPerg)

		If Pergunte( cPerg ,.T.)
			cDepos	:= MV_PAR03	// Deposito destino
			cUbi	:= MV_PAR04	// Ubicacion destino

			u_AGEN02UD(MV_PAR01, MV_PAR02)	// MV_PAR01 = Deposito Origen. | MV_PAR02 = Deposito destino.
		EndIf
	EndIF
Pergunte("MTA260",.F.)
Return

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	AGEN02DD	|	FECHA:	03/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Busco los datos para los documentos.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function AGEN02DD(cDoc, cDepos, cUbi)
Local aArea			:= GetArea()
Local cQry			:= ""
Local aFields		:= {}
Local aCampos		:= {}
Local aButtons  	:= {}
Local dDtValid  
Local aPrdOpc 		:= {}
Local aPrdAcm 		:= {}
Local cQuery		:= " "
Local cPedidoZZJ	:= ""
Local TCBCL
Local cLocOrth		:= ""
Local cLocOrig		:= "" 
Local aAreaSC5 := GetArea("SC5")

	TCBCL  := GetNextAlias() 
	cQuery := "SELECT ZZJ_NUMPED "
	cQuery += " FROM "
	cQuery += RETSQLNAME("ZZJ")+" "
	cQuery += " WHERE "
  //cQuery += " ZZJ_NUMPED BETWEEN  '"+cDoc+"' AND '"+cSerie+"' "
	cQuery += " ZZJ_NUMPED = '"+cDoc+"' "
	cQuery += " AND D_E_L_E_T_ = '' "
	cQuery += " AND ZZJ_ESTADO IN ('03','04') "
  
	If Select("TCBCL") > 0  //En uso
            TCBCL->(DbCloseArea())
    EndIf

	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"TCBCL", .F., .T.)
  //MemoWrite("SecTitPag.sql",cQuery)  	 
    DbSelectArea("TCBCL")
    DbGoTop()
  		
	While !TCBCL->(EOF())
		cPedidoZZJ += "'"+TCBCL->ZZJ_NUMPED+"',"
		TCBCL->(DBSKIP()) 
	EndDO

	If right(Alltrim(cPedidoZZJ),1)==","
		cPedidoZZJ = left(cPedidoZZJ,len(alltrim(cPedidoZZJ))-1)
	EndIf 

	If Empty(cPedidoZZJ) .AND. cEspecie == "PDV" 
		cPedidoZZJ := POSICIONE("SC5",1,XFILIAL("SC5")+cDoc,"C5_NUM")
	ENDIF

If !Empty(cPedidoZZJ)
	TCBCL->(dbCloseArea())

	AADD( aFields, { "TRB_OK"      	,   "C",  2, 0 } )
	AADD( aFields, { "TRB_PRODUC"	,   "C", TamSX3("B1_COD")[1]	, 0 } )
	AADD( aFields, { "TRB_DESCRI"	,   "C", TamSX3("B1_DESC")[1]	, 0 } )
	AADD( aFields, { "TRB_CANTID"	,   "N", TamSX3("D1_QUANT")[1]	, 0 } )
	AADD( aFields, { "TRB_UM"		,   "C", TamSX3("B1_UM")[1]		, 0 } )
	AADD( aFields, { "TRB_LOCAL"	,   "C", TamSX3("B1_LOCPAD")[1]	, 0 } ) //revisar
	AADD( aFields, { "TRB_LOCALI"	,   "C", TamSX3("D3_LOCAL")[1]	, 0 } )	//revisar
	AADD( aFields, { "TRB_PEDIDO"	,   "C", TamSX3("D3_ZPEDIDO")[1], 0 } )
	AADD( aFields, { "TRB_DTVALI"	,   "D", TamSX3("D3_DTVALID")[1], 0 } )
	AADD( aFields, { "TRB_PEDOP"	,   "C", TamSX3("D3_ZITMOP")[1]	, 0 } )

	If cEspecie == "TRF"
		AADD( aFields, { "TRB_XDEV"	,   "C",  1, 0 } )
		//AADD( aFields, { "TRB_XRECORI", "N", 10, 0 } )
	Endif

	cDbfTmp := CriaTrab( aFields, .T. )
	//cNtxTmp := CriaTrab( , .F. )

	IF Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	Endif

	DbUseArea( .T.,__cRDDNTTS, cDbfTmp, "TRB", .f., .f., IIF(.F. .or. .f., !.f., NIL ), .F.)

	If 	cEspecie == "" //OP ALISTAMIENTO
		cQry := " SELECT D4_COD TRB_PRODUC,D4_QUANT TRB_CANTID,D4_LOCAL TRB_LOCAL, D4_OP TRB_PEDIDO, D4_OP PEDOP "+CRLF
		cQry += " FROM "+RetSqlName("SD4")+" SD4 "+CRLF
		cQry += " WHERE SD4.D_E_L_E_T_ <> '*' AND D4_XSTATUS = '' " +CRLF
		cQry += " AND SD4.D4_FILIAL = '"+xFilial("SD4")+"' "+CRLF
		cQry += " AND LEFT(SD4.D4_OP,6) IN (" +cPedidoZZJ + ") "+CRLF
		cQry += " UNION ALL "
		cQry += " SELECT C6_PRODUTO TRB_PRODUC,C6_QTDVEN TRB_CANTID,C6_LOCAL TRB_LOCAL, C6_NUM TRB_PEDIDO,C6_NUM PEDOP  "+CRLF
		cQry += " FROM "+RetSqlName("SC6")+" SC6 "+CRLF
		cQry += " WHERE SC6.D_E_L_E_T_ <> '*'  " +CRLF
		cQry += " AND SC6.C6_FILIAL = '"+xFilial("SC6")+"' "+CRLF
		cQry += " AND C6_NUM =  '" +cDoc + "' "+CRLF
		cQry += " AND C6_OPC = '' AND C6_XSTATUS = '' "+CRLF
	
	ElseIF cEspecie == "OPD" //OP DESPACHO
		//cQry := " SELECT D3_COD TRB_PRODUC, D3_QUANT TRB_CANTID, D3_LOCAL TRB_LOCAL, LEFT(D3_ZPEDIDO,6) TRB_PEDIDO "+CRLF
		cQry := " SELECT D3_COD TRB_PRODUC, D3_QUANT TRB_CANTID, D3_LOCAL TRB_LOCAL, CONCAT (LEFT(D3_ZPEDIDO,6),'D') TRB_PEDIDO, D3_ZPEDIDO TRB_PEDOP "+CRLF
		cQry += " FROM "+RetSqlName("SD3")+" SD3 "+CRLF
		cQry += " WHERE SD3.D_E_L_E_T_ <> '*' AND SD3.D3_LOCAL =  '" +getnewpar(AllTrim("MV_LCLALS"),"31")+"'" +CRLF
		cQry += " AND SD3.D3_FILIAL = '"+xFilial("SD3")+"' AND D3_ZITMOP != 'OK' "+CRLF
		cQry += " AND LEFT(SD3.D3_ZPEDIDO,6) IN (" +cPedidoZZJ + ") "+CRLF 
		cQry += " AND SUBSTRING(SD3.D3_ZPEDIDO,7,1) != 'D' "+CRLF 

	ElseIF cEspecie == "PDV" //PDV
		cQry := " SELECT C6_PRODUTO TRB_PRODUC,C6_QTDVEN TRB_CANTID,C6_LOCAL TRB_LOCAL, C6_NUM TRB_PEDIDO,C6_NUM TRB_PEDOP  "+CRLF
		cQry += " FROM "+RetSqlName("SC6")+" SC6 "+CRLF
		cQry += " WHERE SC6.D_E_L_E_T_ <> '*'  " +CRLF
		cQry += " AND SC6.C6_FILIAL = '"+xFilial("SC6")+"' "+CRLF
		cQry += " AND C6_NUM =  '" +cDoc + "' "+CRLF
		cQry += " AND C6_OPC = ''  AND C6_XSTATUS = '' "+CRLF

	ElseIF cEspecie == "TRF" //MOV.TRANFERENCIA
		cQry := " SELECT D3_FILIAL,D3_DOC,D3_EMISSAO,D3_COD TRB_PRODUC,D3_UM,D3_QUANT TRB_CANTID,SD3.D3_LOCAL TRB_LOCAL"+CRLF
		cQry += " ,(SELECT D3_LOCAL "+CRLF
		cQry += " 	FROM "+RetSqlName("SD3")+" XD3 "		+CRLF
		cQry += " 	WHERE SD3.D3_FILIAL = XD3.D3_FILIAL "	+CRLF
		cQry += " 		AND SD3.D3_DOC = XD3.D3_DOC "		+CRLF
		cQry += " 		AND SD3.D3_NUMSEQ=XD3.D3_NUMSEQ"	+CRLF
		cQry += " 		AND XD3.D3_TM='999' AND XD3.D3_CF='RE4' AND XD3.D3_CHAVE='E0' "+CRLF
		cQry += " 		AND XD3.D_E_L_E_T_ <> '*' ) TRB_LOCALI"	+CRLF
		cQry += " , SD3.D3_XDEV TRB_XDEV, SD3.D3_XRECORI TRB_XRECORI " +CRLF
		cQry += " FROM "+RetSqlName("SD3")+" SD3 "					+CRLF
		cQry += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "' "	+CRLF
		cQry += " 	AND SD3.D3_DOC =  '" + cTrf + "' " 				+CRLF
		cQry += " 	AND (D3_TM='499' AND D3_CF='DE4' AND D3_CHAVE='E9')"+CRLF
		cQry += " 	AND SD3.D3_XDEV<>'S' AND SD3.D_E_L_E_T_ <> '*' "

	EndIf
	cQry := ChangeQuery(cQry)
	SqlToTrb( cQry, aFields, 'TRB' )

	TCSetField( 'TRB', 'TRB_CANTID'	, 'N',TamSX3("D1_QUANT")[1], 2 )
	TCSetField( 'TRB', 'TRB_VALID'	, 'D',8, 2 )

		("TRB")->(DbGoTop())

	Do Case
	Case cEspecie = "OPD" //alistamiento
		If ("TRB")->(!Eof())    
		dbSelectArea("SC5")
		dbSetOrder(1)
			If dbSeek(xFilial("SC5")+cDoc)
			dbSelectArea("SA1")
			dbSetOrder(1)
				If dbSeek(xFilial("SA1")+SC5->C5_ZZORTOP+SC5->C5_ZZLJORT)
				cLocOrth 	:= SA1->A1_XLOCAL
				EndIf
			DbCloseArea("SA1")
			ENDIF
		DbCloseArea("SC5")
		EndIf
		cLocOrth	:= If(EMPTY(cLocOrth),"20",cLocOrth)
		cLocOrig := getnewpar(AllTrim("MV_LCLALS"),"31")
	Case cEspecie = ""
		cLocOrth := getnewpar(AllTrim("MV_LCLALS"),"31")
		cLocOrig := getnewpar(AllTrim("MV_LCLDIS"),"20")
	Case cEspecie = "PDV" //pedido venta
		If Empty(cDepos) 
		 cLocOrth := getnewpar(AllTrim("MV_LCLALS"),"31")
		Else 
		 cLocOrth := cDepos
		Endif
		cLocOrig := getnewpar(AllTrim("MV_LCLDIS"),"20")	
	
	EndCase
	

	While ("TRB")->(!Eof())    
		
		If cEspecie == "TRF" //Mov.Transferencia			
			AADD(aColsTRB,{	.F.,;			// 1
						TRB->TRB_PRODUC	,;	// 2
						POSICIONE("SB1",1,XFILIAL("SB1")+TRB->TRB_PRODUC,"B1_DESC"),;	// 3
						TRB->TRB_CANTID	,;	// 4
						POSICIONE("SB1",1,XFILIAL("SB1")+TRB->TRB_PRODUC,"B1_UM"),;		// 5
						TRB->TRB_LOCAL 	,;  // 6
						cDepos			,;	// 7
						TRB->TRB_LOCALI	,;	// 8
						TRB->TRB_PEDIDO	,;	// 9
						TRB->TRB_PEDOP 	,;	// 10
						TRB->TRB_XDEV  	})	// 11
					//TRB->TRB_XRECORI})	// 12
							
		Else		
			AADD(aColsTRB,{	.F.,;			// 1
						TRB->TRB_PRODUC,;	// 2
						POSICIONE("SB1",1,XFILIAL("SB1")+TRB->TRB_PRODUC,"B1_DESC"),;	// 3
						TRB->TRB_CANTID,;	// 4
						POSICIONE("SB1",1,XFILIAL("SB1")+TRB->TRB_PRODUC,"B1_UM"),;		// 5
						cLocOrig,;  		// 6
						cDepos,;			// 7
						cLocOrth,;			// 8
						TRB->TRB_PEDIDO,;	// 9
						TRB->TRB_PEDOP })	// 10						
		Endif				

		DbSelectArea("TRB")
		dbSkip()
	EndDo
//	Next nX
EndIf
	IF Len(aColsTRB) == 0
		MsgInfo("No hay datos para visualizar.")
		Return nil
	EndIF

	u_ARGEN2MB(aColsTRB)

//	DbUnlockAll()
	DbSelectArea( 'TRB' )
	DbCloseArea()

RestArea(aAreaSC5)
RestArea(aArea)

Return NIL

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGE2I	|	FECHA:	09/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Permite seleccionar archivo a importar.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function ARGE2I()
Local nPanel := 1
Local oDlgA, oBmp1, oBmp2, oGet
Local cType  := "Archivo CSV | *.CSV "
Local MvPar  := &(Alltrim(ReadVar()))
Local mvRet  := Alltrim(ReadVar())

Private nOpa  := 0

	DEFINE FONT oFont NAME "Arial" SIZE 000,020 BOLD

	DEFINE DIALOG oDlgA FROM 000,000 TO 300,480 TITLE OemToAnsi('Carga masiva de Items') PIXEL

	@ 010, 120 SAY 'Carga masiva de Items'	SIZE 100, 010 PIXEL OF oDlgA FONT oFont
	@ 020, 120 SAY 'Ottobock'                	SIZE 100, 010 PIXEL OF oDlgA FONT oFont

	@ 035, 050 TO 130, 230 OF oDlgA PIXEL
	@ 000, 050 BITMAP oBmp1 RESNAME "APLOGO" OF oDlgA SIZE 100,200 NOBORDER  WHEN .F. PIXEL
	@ 000, 000 BITMAP oBmp2 RESNAME "LOGIN"  OF oDlgA SIZE 050,155 NOBORDER  WHEN .F. PIXEL

	@ 110,070 MSGET oGet VAR cFile SIZE 125,10 PIXEL OF oDlgA
	@ 110,200 BUTTON OemToAnsi("...") SIZE 15,10 PIXEL OF oDlgA ACTION cFile := Padr( cGetFile(cType, OemToAnsi("Seleccione el archivo "+Subs(cType,1,6)),0,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY), 255 )

	DEFINE SBUTTON FROM  135, 170 TYPE 1 ACTION (Iif(TudoOk(),oDlgA:End(),.F.)) ENABLE PIXEL OF oDlgA
	DEFINE SBUTTON FROM  135, 200 TYPE 2 ACTION (nOpa := 0, oDlgA:End()) ENABLE PIXEL OF oDlgA
	ACTIVATE DIALOG oDlgA CENTERED

	If nOpa == 1
		&MvRet := cFile
	EndIf

Return(.T.)

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ArmoPantalla	|	FECHA:	07/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Armo la pantalla para solicitar documentos.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function ArmoPantalla()
Local oDlgP, oGet
Local lOk	:= .F.
Local nOpca	:= 0
Local cConsulta := ""
Local cConsClie := ""

	DEFINE FONT oFont NAME "Arial" SIZE 000,020 BOLD
	//																  Y	  X
	DEFINE DIALOG oDlgP TITLE "Seleccione los Documentos" FROM 0,0 TO 250,350 PIXEL

	// Y  X
	@ 016,020 Say OemToAnsi("Tipo de Documentos") Size 50,8 OF oDlgP PIXEL
	@ 015,070 ComboBox cGenera Items aGenera Size 75,60 OF oDlgP PIXEL

	DEFINE SBUTTON FROM  100, 060 TYPE 1 ACTION (nOpca:=1, oDlgP:End()) ENABLE PIXEL OF oDlgP
	DEFINE SBUTTON FROM  100, 090 TYPE 2 ACTION (nOpca:=0, oDlgP:End()) ENABLE PIXEL OF oDlgP
	
	ACTIVATE DIALOG oDlgP CENTERED

	IF nOpca == 1
		nOpca:=0

			DEFINE FONT oFont NAME "Arial" SIZE 000,020 BOLD
			//																  Y	  X
			DEFINE DIALOG oDlgP TITLE "Seleccione los Documentos" FROM 0,0 TO 250,350 PIXEL

			cEspAux := BuEspecie(cGenera)

			IF cEspAux $ cSD2Espe
				cConsulta := "ZZJPED"
				cConsClie := "SA1"	// Cliente
			ElseIF cEspAux $ cSD1Espe
					cConsulta := "ZZJPED"
					cConsClie := "FOR"	// Proveedor
				Else
					cConsulta := "ZZJPED"
			EndIF

			If cEspAux == "TRF"
				@ 016,020 Say OemToAnsi("Transferencia Multiple") Size 50,8 OF oDlgP PIXEL
				@ 015,070 MSGET cTrf SIZE 55, 06 OF oDlgP PIXEL F3 cConsulta
			Else
				@ 016,020 Say OemToAnsi("De pedido") Size 50,8 OF oDlgP PIXEL
				@ 015,070 MSGET cDoc SIZE 55, 06 OF oDlgP PIXEL F3 cConsulta
			Endif
			
			If cEspAux = "PDV"
				@ 031,020 Say OemToAnsi("Almacen Destino") Size 50,8 OF oDlgP PIXEL	// 36
				@ 030,070 MSGET cDepos SIZE 55, 06  OF oDlgP PIXEL  F3 "NNR" 	// 35
			EndIf
		  	//@ 015,070 MSGET cDoc   SIZE 55, 06 VALID ARGEN02V(cDoc)   OF oDlgP PIXEL  F3 cConsulta
			/*
			@ 046,020 Say OemToAnsi("Cliente/Proveedor") Size 50,8 OF oDlgP PIXEL	// 36
			@ 045,070 MSGET cCliente SIZE 55, 06 OF oDlgP PIXEL F3 cConsClie	// 35

			@ 061,020 Say OemToAnsi("Loja") Size 50,8 OF oDlgP PIXEL
			@ 060,070 MSGET cLoja SIZE 55, 06 OF oDlgP PIXEL

			@ 076,020 Say OemToAnsi("DepOsito destino") Size 50,8 OF oDlgP PIXEL	// 56
			@ 075,070 MSGET cDepos SIZE 25, 06 VALID IIF(!Empty(cDepos),ExistCpo("ZZ1",cDepos),.T.) OF oDlgP PIXEL F3 "ZZ1"	// 55

			@ 091,020 Say OemToAnsi("UbicaciOn destino") Size 50,8 OF oDlgP PIXEL	// 76
			@ 090,070 MSGET cUbi SIZE 55, 06 VALID IIF(!Empty(cUbi) .AND. !Empty(cDepos),ExistCpo("SBE", cDepos + cUbi),.T.) OF oDlgP PIXEL F3 "SBE"	// 75
			*/
			DEFINE SBUTTON FROM  105, 060 TYPE 1 ACTION (nOpca:=1, oDlgP:End()) ENABLE PIXEL OF oDlgP
			DEFINE SBUTTON FROM  105, 090 TYPE 2 ACTION (nOpca:=0, oDlgP:End()) ENABLE PIXEL OF oDlgP
	
			ACTIVATE DIALOG oDlgP CENTERED

			If nOpca == 1
				lOk := .T.

				cEspecie := BuEspecie(cGenera)
			EndIf
	EndIF

Return lOk

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	BuEspecie	|	FECHA:	03/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Busco la especie.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function BuEspecie(cGenera)
Local cEspeAux:= ""

	Do Case
		Case cGenera = "Tras. Alistamiento"
			cEspeAux := ""
		Case cGenera = "Tras. Despacho"
			cEspeAux := "OPD"
		Case cGenera = "Tras. Pedido venta"
			cEspeAux := "PDV"
		Case cGenera = "Mov.Transferencia"
			cEspeAux := "TRF"
		/*
		Case cGenera == "Pedido venta"
			cEspeAux := "PDV"
		Case cGenera == "Pedido Venta"
			cEspeAux := "PDV"
		Case cGenera = "Remito Ventas Devoluciï¿½n"
			cEspeAux := "RFD"
		Case cGenera = "Factura Compras"
			cEspeAux := "NF "
		Case cGenera = "Movimientos Internos"
			cEspeAux := "SD3"	// No es una especie. 
		*/
	EndCase

Return cEspeAux

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGEN2MB	|	FECHA:	07/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Armo el MarkBrowse
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function ARGEN2MB(aColsTRB)
Local cCadastro := OemToAnsi("Carga masiva de Items")
Local nCol			:= 1
Local rBmpOk   	:= LoadBitmap(GetResources(), "LBOK")	// Carga 1 bitmap Cuadrado con X
Local rBmpNo   	:= LoadBitmap(GetResources(), "LBNO")	// Carga 1 bitmap Cuadrado
Local aButtons  := {}

	// Genero la cabecera.	
	
	aHeadTRB := {'',;										// 1 - OK
					AllTrim(OemToAnsi("Producto"))		,;	// 2 - Producto
					AllTrim(OemToAnsi("Descripcion"))	,;	// 3
					AllTrim(OemToAnsi("Cantidad"))		,;	// 4
				   	AllTrim(OemToAnsi("Unid Medida"))	,;	// 5
					AllTrim(OemToAnsi("Depos Orig"))	,;	// 6
					AllTrim(OemToAnsi("Depos Desti"))	,;	// 8
					AllTrim(OemToAnsi("Pedido"))		 }	// 9
					
	aSizes   := {20,60,40,40,40,40,40,40,40}
	
	If cEspAux=='TRF'
		aHeadTRB := {''									,;	// 1 - OK
					AllTrim(OemToAnsi("Producto"))		,;	// 2 - Producto
					AllTrim(OemToAnsi("Descripcion"))	,;	// 3
					AllTrim(OemToAnsi("Cantidad"))		,;	// 4
				   	AllTrim(OemToAnsi("Unid Medida"))	,;	// 5
					AllTrim(OemToAnsi("Depos Orig"))	,;	// 6
					AllTrim(OemToAnsi("Depos Desti"))	,;	// 8
					AllTrim(OemToAnsi("Pedido"))		,;	// 9
					AllTrim(OemToAnsi("Devolucion"))	,; 	// 10
					AllTrim(OemToAnsi("Recno Dev"))		}	// 11
					
		aSizes   := {20,60,40,40,40,40,40,40,40,40,40}
	Endif
	

	DEFINE MSDIALOG oDlg FROM 0,0 TO 450,790 PIXEL TITLE "Elija Los Productos Transferir"

	// TWBrowse con MarkBrowse
	// Posiciones: Vertice Sup+Izq (Fila,Col) y Vertice Inf+Der (Col,Fila) // Este ultimo punto es (y,x) al reves del resto: (x,y)
	oMark := TWBrowse():New(020+10, 010, 370, 190,,aHeadTRB,aSizes,oDlg,,,,,,,,,,,,,, .T.)
	oMark:SetArray(aColsTRB)

	//Aqui define el MarkBrowse
	oMark:bLine := {||{ IF(aColsTRB[oMark:nAt,01],rBmpOk,rBmpNo),;
					aColsTRB[oMark:nAt,02],;
					aColsTRB[oMark:nAt,03],;
					aColsTRB[oMark:nAt,04],;
					aColsTRB[oMark:nAt,05],;
					aColsTRB[oMark:nAt,06],;
					aColsTRB[oMark:nAt,08],;
					aColsTRB[oMark:nAt,09]}}
					//aColsTRB[oMark:nAt,07]}}//,;

	//Marca y desmarca linea del MarkBrowse
	oMark:blDblClick := {|rows, col| If(Alltrim(aColsTRB[oMark:nAt,2])=="",Nil,aColsTRB[oMark:nAt,1]:=!aColsTRB[oMark:nAt,1]),oMark:Refresh()}

	//Marca y desmarca todas las lineas del MarkBrose
	oMark:bHeaderClick := {|oObj, nCol| If(nCol == 1, fMarkAll(aColsTRB), Nil), oMark:Refresh()}
	Aadd(aButtons ,{"DOCUMENTO.PNG"	,	{|| FindArq(oMark,aColsTRB) }	, "Buscar producto" , "Buscar " })	
	Activate Dialog oDlg ON INIT (EnchoiceBar(oDlg,{|| u_ARGEN02C(aColsTRB),oDlg:End()},{||oDlg:End()},,@aButtons)) Centered

Return

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	FMarkAll	|	FECHA:	07/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Marco y desmarco toda la primer columna
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function FMarkAll(aVet)

	Local lMk := !aVet[1, 1]
	Local nX  := 1
	
	If Len(aVet) == 1 .And. Alltrim(aVet[1,2]) == ""
		Return aVet
	EndIf

	For nX := 1 To Len(aVet)
		aVet[nX, 1] := lMk
	Next nX
	
Return aVet

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGEN02C	|	FECHA:	04/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Opciï¿½n de Copiar.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function ARGEN02C(aColsTRB)
Local aArea	:= GetArea()
Local nPos	:= 1
Local nX 	:= 0
Local nI 	:= 0
Local nCantid	:= 0

// En el fuente padron esta hardcodeada las posiciones del acols.
Local nPosCodO	:= 1	// Producto Origen
Local nPosDepO	:= 4	// Deposito Origen
Local nPosUbiO	:= 5	// Ubicacion Origen
Local nPosUMOr	:= 3	// Unidad de Medida Origen
Local nPsLoTCT	:= 12	// Lote Origen
Local nPosDTVL	:= 14	// Fecha valida origen

Local nPosCodD	:= 6 	// Producto Destino
Local nPosDepD	:= 9 	// Deposito Destino
Local nPosUbiD	:= 10	// Ubicacion Destino
Local nPosUMDe	:= 8	// Unidad de Medida Destino
Local nPsCTLDe	:= 20	// Lote Destino
Local nPsDTVLD	:= 21	// Fecha valida Destino
Local nPosDDes	:= 7

Local nPosCant	:= aScan(aHeader,{|x| Trim(x[2]) == "D3_QUANT"} ) 
Local nPosDesc	:= aScan(aHeader,{|x| Trim(x[2]) == "D3_DESCRI"} ) 
Local cNumLote	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_NUMLOTE'})
Local nNumPedd	:= aScan(aHeader,{|x| Trim(x[2]) == "D3_ZPEDIDO"} ) 
Local nPosDev	:= aScan(aHeader,{|x| Trim(x[2]) == "D3_XDEV"} ) 
Local nPosRecn	:= aScan(aHeader,{|x| Trim(x[2]) == "D3_XRECORI"} ) 


Local cLoteAuto	:= "AUTO"

Local cLog		:= ""
Local cFileLog	:= ""
Local cPath		:= ""
Local dDtValid	:= CTOD("  /  /  ")

Local lProceso	:= .T.

Local nCantSB8	:= 0
Local nSalAux	:=  0

	AutoGrLog( "Fecha Inicio.......: " + Dtoc(MsDate()) )
	AutoGrLog( "Hora Inicio........: " + Time() )
	AutoGrLog( "Environment........: " + GetEnvServer() )
	AutoGrLog( "Empresa / Sucural..: " + SM0->M0_CODIGO + "/" + SM0->M0_CODFIL )
	AutoGrLog( "Razon Social.......: " + Capital( Trim( SM0->M0_NOME) ) )
	AutoGrLog( "Usuario............: " + SubStr( cUsuario, 7, 15 ) )
	AutoGrLog( "Archivo............: " + Alltrim( Lower( cFile ) ) )
	AutoGrLog( " " )

	FOR nI := 1 To Len(aColsTRB)
		IF aColsTRB[nI][1] == .T.
			lProceso := .T.

			//IF !Empty(aColsTRB[nI][LOTE])
				// Valido que exista el lote.
			//	lProceso := ValidoLote( aColsTRB[nI][PRODUC], aColsTRB[nI][LOCALD], aColsTRB[nI][LOTE], nI )
//				nCantSB8 := ValidoLote( aColsTRB[nI][PRODUC], aColsTRB[nI][LOCALD], aColsTRB[nI][LOTE] )
			//EndIF

			IF lProceso
//			IF nCantSB8 > 0
										// 					Producto,	Deposito, 	Ubicacion
				nSalAux := BuSaldo( aColsTRB[nI][PRODUC], aColsTRB[nI][LOCALD], "", "" )

				// Creo el registro en la SB2 si no existe.
				iF cEspecie == ''
					CreoSB2( aColsTRB[nI][PRODUC], aColsTRB[nI][LOTE] )
				ELSE
					CreoSB2( aColsTRB[nI][PRODUC], aColsTRB[nI][LOCALI] )
				endif
				
				// Si el saldo del producto y el local es mayor a 0.
				IF nSalAux >=  aColsTRB[nI][CANTID]
					// Creo una nueva linea en aCols
					IF nPos > 1
						CreoaCols(nPos)
					EndIF

					FOR nX := nPos To Len(aCols)
						// Archivo: la cantidad viene en Char
						IF ValType(aColsTRB[nI][CANTID]) == "C"
							nCantid := Val(AllTrim(aColsTRB[nI][CANTID]))
						Else
							nCantid := aColsTRB[nI][CANTID]
						EndIF 
				
						aCols[nX][nPosCant] := nCantid
                  
						// ORIGEN
						aCols[nX][nPosCodO]	:= aColsTRB[nI][PRODUC]	// Producto
						aCols[nX][nPosDesc]	:= aColsTRB[nI][DESCRI]	// Descripcion
						aCols[nX][nPosUMOr]	:= aColsTRB[nI][UM]		// Unidad de medida
						aCols[nX][nPosDepO]	:= aColsTRB[nI][LOCALD]	// Deposito
						aCols[nX][nPosDepD]	:= aColsTRB[nI][LOCALI]	// Deposito destino

						dDtValid := IIF(Empty(aColsTRB[nI][DTVALI]),dFecAux, aColsTRB[nI][DTVALI])

						IF ValType(dDtValid) == "C"
							dDtValid := STOD(dDtValid)
						EndIF

						IF AllTrim(aColsTRB[nI][LOCALD]) == "MT" .AND. nOpcEnchoi == 1 .AND. AllTrim(cEspecie) == "NF"
							IF !cLoteAuto $ aColsTRB[nI][LOTE]
								//aCols[nX][nPsLoTCT]	:= aColsTRB[nI][LOTE]	// Lote
								aCols[nX][nPosDTVL]	:= dDtValid	// Fecha de validez
							Else
								aCols[nX][nPsLoTCT]	:= ""	// Lote
								aCols[nX][nPosDTVL]	:= CTOD("  /  /  ")	// Fecha de validez
							EndIF
						Else
							aCols[nX][nNumPedd]	:= aColsTRB[nI][DTVALI]	// Num Pedido
							aCols[nX][nPosDTVL]	:= dDtValid	// Fecha de validez
						EndIF

						//M->D3_LOTECTL		:= aCols[nX][nPsLoTCT]
						//M->D3_NUMLOTE		:= ""
						M->D3_DTVALID		:= aCols[nX][nPosDTVL]
						ARGE02LOTE(1)
                        

                        
						// DESTINO
						aCols[nX][nPosCodD]	:= aColsTRB[nI][PRODUC]	// Producto
						aCols[nX][nPosDDes]	:= aColsTRB[nI][DESCRI]	// Descripcion
						aCols[nX][nPosUMDe]	:= aColsTRB[nI][UM]		// Unidad de medida
					    				
					
						IF AllTrim(aColsTRB[nI][LOCALD]) == "MT" .AND. nOpcEnchoi == 1 .AND. AllTrim(cEspecie) == "NF"
							IF !cLoteAuto $ aColsTRB[nI][LOTE]
								//aCols[nX][nPsLoTCT]	:= aColsTRB[nI][LOTE]	// Lote
								aCols[nX][nPosDTVL]	:= dDtValid	// Fecha de validez
							Else
								//aCols[nX][nPsLoTCT]	:= ""	// Lote
								aCols[nX][nPosDTVL]	:= CTOD("  /  /  ")	// Fecha de validez
							EndIF
						Else
							aCols[nX][nNumPedd]	:= aColsTRB[nI][DTVALI]	// Num Pedido
							aCols[nX][nPosDTVL]	:= dDtValid	// Fecha de validez
							If cEspecie == "OPD"
								aCols[nX][24]	:= aColsTRB[nI][10]	// Item de orden de prod en despacho
							EndIf
						EndIF

						//M->D3_LOTECTL		:= aColsTRB[nI][LOTE]	// Lote
						M->D3_NUMLOTE		:= ""
						M->D3_DTVALID		:= dDtValid
						ARGE02LOTE(2)


						IF !Empty(cDepos)
							aCols[nX][nPosDepD]	:= cDepos	// Deposito
						Else
							aCols[nX][nPosDepD]	:= aColsTRB[nI][LOTE]
						EndIF
			
						IF !Empty(cUbi)
							aCols[nX][nPosUbiD]	:= cUbi		// Ubicacion
						EndIF
						aCols[nX][nPsDTVLD]	:= dDtValid	// Fecha de validez
						
						If !Empty(cTrf)
							If nPosDev > 0
								aCols[nX][nPosDev]	:= "S"	//aColsTRB[nI][LOTE]
							//	aCols[nX][nPosRecn]	:= aColsTRB[nI][LOTE]
							Endif
						Endif
						
						nPos++

					Next nX
				Else                                                                                                                                                                                                                     
					cLog  := 'Registro ' + Alltrim( Str( nI ) ) + ' El producto: '+aColsTRB[nI][PRODUC]+' No tiene saldo para el Deposito: '+aColsTRB[nI][LOCALD] + IIF(!Empty(aColsTRB[nI][LOCALI])," Deposito: " + aColsTRB[nI][LOCALI],"") + IIF(!Empty(aColsTRB[nI][LOTE])," Lote: ", "")+"  ( SB2)."
					AutoGrLog( cLog )
				EndIF
			Else
//				cLog  := 'Registro ' + Alltrim( Str( nI ) ) + ' El lote: '+aColsTRB[nI][LOTE]+' para el producto: '+aColsTRB[nI][PRODUC]+' y el Deposito: '+aColsTRB[nI][LOCALD]+' tiene saldo cero o no existe. (SB8).'
//				AutoGrLog( cLog )
			EndIF
		EndIF
	Next nI

	AutoGrLog( "  " )
	AutoGrLog( "Fecha Fin..........: " + Dtoc(MsDate()) )
	AutoGrLog( "Hora Fin...........: " + Time() )

	cFileLog := NomeAutoLog()

	If cFileLog <> ""
	   nX := 1
	   While .t.
    	  If File( Lower( '\interlog\' + Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
        	 nX++
	         If nX == 999
    	        Exit
        	 EndIf
	         Loop
    	  Else
        	 Exit
	      EndIf
	   EndDo
	   __CopyFile( cPath + Alltrim( cFileLog ), Lower( '\interlog\' + Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
	   MostraErro(cPath,cFileLog)
	   FErase( cFileLog )
	Endif

RestArea(aArea)

Return

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	CreoaCols	|	FECHA:	04/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Monto el aCols para ingresar un nuevo registro.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function CreoaCols(nPos)
Local nX  := 1

	ADHeadRec("SD3",aHeader)

	aAdd(aCols, Array(Len(aHeader)+1))

	For nX := 1 To Len(aHeader)
		cCampo:=Alltrim(aHeader[nX,2])
		If IsHeadRec(aHeader[nX][2])
			aCols[nPos][nX] := 0
		ElseIf IsHeadAlias(aHeader[nX][2])
			aCols[nPos][nX] := "SD3"
		ElseIf aHeader[nX,8] == 'C'
			aCols[nPos,nX] := Space(aHeader[nX,4])
		ElseIf aHeader[nX,8] == 'N'
			aCols[nPos,nX] := 0
		ElseIf aHeader[nX,8] == "D" .And. cCampo != "D3_DTVALID"
			aCols[nPos][nX] := dDataBase
		ElseIf aHeader[nX,8] == "D" .And. cCampo == "D3_DTVALID"
			aCols[nPos][nX] := CriaVar("D3_DTVALID")
		ElseIf aHeader[nX,8] == 'M'
			aCols[nPos,nX] := ''
		Else
			aCols[nPos,nX] := .F.
		EndIf
	Next nX
	
	aCols[nPos,Len(aHeader)+1] := .F.

Return

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	BUSALDO	|	FECHA:	04/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Busco el saldo por producto y por local.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function BuSaldo(cProdSal, cLocalSal, cUbicSal, cLoteSal)
Local aArea		:= GetArea()
Local aAreaSBF	:= SBF->(GetArea())
Local aAreaSB2	:= SB2->(GetArea())
Local TMP_SBF	:= GetNextAlias()
Local nSaldoAux	:= 0
Local cQry		:= ""

	IF Empty(cUbicSal)
		SB2->(DbSetOrder(1))
		If SB2->(dbSeek(xFilial('SB2') + cProdSal + cLocalSal))
			nSaldoAux := SaldoMov(NIL,NIL,NIL,Nil)
		EndIF
	Else
		IF Select(TMP_SBF) > 0
			DbSelectArea(TMP_SBF)
			DbCloseArea()
		Endif

		cQry := "SELECT ( BF_QUANT - BF_EMPENHO) CANTIDAD "
		cQry += "FROM "+RetSqlName("SBF")+" SBF "+CRLF
		cQry += "WHERE D_E_L_E_T_ <> '*' "+CRLF
		cQry += "AND BF_FILIAL = '"+xFilial("SBF")+"' "+CRLF
		cQry += "AND BF_PRODUTO = '"+cProdSal+"' "+CRLF
		cQry += "AND BF_LOCAL 	= '"+cLocalSal+"' "+CRLF
		IF !Empty(cUbicSal)
			cQry += "AND BF_LOCALIZ = '"+cUbicSal+"'"+CRLF
		EndIF
		IF !Empty(cLoteSal)
			cQry += "AND BF_LOTECTL = '"+cLoteSal+"'"+CRLF
		EndIF

		cQry := ChangeQuery(cQry)
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), TMP_SBF, .F., .T.)

		DbSelectArea(TMP_SBF)
		DbGoTop()

		IF (TMP_SBF)->(!Eof())
			nSaldoAux := (TMP_SBF)->CANTIDAD
		EndIF

		IF Select(TMP_SBF) > 0
			DbSelectArea(TMP_SBF)
			DbCloseArea()
		Endif
	EndIF

RestArea(aAreaSB2)
RestArea(aAreaSBF)
RestArea(aArea)

Return nSaldoAux
/*
Static Function BuSaldo(cProdSal, cLocalSal)
Local aArea := GetArea()
Local aAreaSB2 := SB2->(GetArea())
Local nSaldoAux	:= 0

	SB2->(DbSetOrder(1))
	If SB2->(dbSeek(xFilial('SB2') + cProdSal + cLocalSal))
		nSaldoAux := SaldoMov(NIL,NIL,NIL,Nil)
	EndIF

RestArea(aAreaSB2)
RestArea(aArea)

Return nSaldoAux
*/



/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	BUSALDO	|	FECHA:	11/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Funcion que contiene la funcion CRIASB2().
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function CreoSB2(cProdSal, cLocalSal)
Local aArea := GetArea()
Local aAreaSB2 := SB2->(GetArea())

Default	cProdSal	:= ""
Default	cLocalSal	:= ""

	// Si no existe relaciï¿½n Producto con Deposito, lo creo.
	SB2->(DbSetOrder(1))
	IF !SB2->(dbSeek(xFilial("SB2") + cProdSal + cLocalSal))
		CriaSb2( cProdSal, cLocalSal )
	Endif

RestArea(aAreaSB2)
RestArea(aArea)

Return

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	BUSALDO	|	FECHA:	08/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Busco los datos para el deposito y la ubicacion.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function AGEN02UD(cDeposOri, cUbicOri)
Local cQry		:= ""
Local aFields	:= {}
Local aCampos	:= {}
Local aProdSBF	:= {}
Local nSaldoAux	:= 0
Local nI		:= 0

	AADD( aFields, { "TRB_OK"    	,	"C",  2, 0 } )
	AADD( aFields, { "TRB_PRODUC"	,   "C", TamSX3("B1_COD")[1]	, 0 } )
	AADD( aFields, { "TRB_DESCRI"	,   "C", TamSX3("B1_DESC")[1]	, 0 } )
	AADD( aFields, { "TRB_CANTID"	,   "N", TamSX3("D1_QUANT")[1]	, 0 } )
	AADD( aFields, { "TRB_UM"		,   "C", TamSX3("B1_UM")[1]		, 0 } )
	AADD( aFields, { "TRB_LOCAL"	,   "C", TamSX3("DA_LOCAL")[1]	, 0 } )
	AADD( aFields, { "TRB_LOCALI"	,   "C", TamSX3("B2_LOCALIZ")[1], 0 } )
	AADD( aFields, { "TRB_LOTE"		,   "C", TamSX3("DA_LOTECTL")[1], 0 } )
	AADD( aFields, { "TRB_DTVALI"	,   "D", TamSX3("D3_DTVALID")[1], 0 } )

	cDbfTmp := CriaTrab( aFields, .T. )
	cNtxTmp := CriaTrab( , .F. )

	IF Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	Endif

	DbUseArea( .T.,__cRDDNTTS, cDbfTmp, "TRB", .f., .f., IIF(.F. .or. .f., !.f., NIL ), .F.)

	// Busco las ubicaciones
	IF !Empty(cUbicOri)
		cQry := "SELECT ' ' TRB_OK, SBF.BF_PRODUTO TRB_PRODUC, SB1.B1_DESC TRB_DESCRI, (SBF.BF_QUANT  - SBF.BF_EMPENHO) TRB_CANTID, "
		cQry += "SB1.B1_UM TRB_UM, SBF.BF_LOCAL TRB_LOCAL, SBF.BF_LOCALIZ TRB_LOCALI, SBF.BF_LOTECTL TRB_LOTE, "
		cQry += "SBF.BF_DATAVEN TRB_DTVALI "	
		cQry += "FROM "+RetSqlName("SBF")+" SBF, "+RetSqlName("SB1")+" SB1 "+CRLF
		cQry += "WHERE SBF.D_E_L_E_T_ <> '*' "+CRLF
		cQry += "AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_MSBLQL <> '1' "+CRLF
		cQry += "AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
		cQry += "AND SBF.BF_FILIAL = '"+xFilial("SBF")+"' "+CRLF
		cQry += "AND SBF.BF_LOCAL = '"+cDeposOri+"' "+CRLF
		cQry += "AND SBF.BF_LOCALIZ = '"+cUbicOri+"' "+CRLF
		cQry += "AND SBF.BF_PRODUTO = SB1.B1_COD "+CRLF
		cQry += "AND (SBF.BF_QUANT - SBF.BF_EMPENHO) > 0"+CRLF	// cQry += "ORDER BY SBF.BF_PRODUTO"
	Else
		// Busco los depositos
		cQry := "SELECT ' ' TRB_OK, SB2.B2_COD TRB_PRODUC, SB1.B1_DESC TRB_DESCRI, SB2.B2_QATU TRB_CANTID, "
		cQry += "SB1.B1_UM TRB_UM, SB2.B2_LOCAL TRB_LOCAL, ' ' TRB_LOCALI, ' ' TRB_LOTE, "
		cQry += "' ' TRB_DTVALI "
		cQry += "FROM "+RetSqlName("SB2")+" SB2, "+RetSqlName("SB1")+" SB1 "+CRLF
		cQry += "WHERE SB2.D_E_L_E_T_ <> '*' "+CRLF
		cQry += "AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_MSBLQL <> '1' "+CRLF
		cQry += "AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
		cQry += "AND SB2.B2_FILIAL = '"+xFilial("SB2")+"' "+CRLF
		cQry += "AND SB2.B2_LOCAL = '"+cDeposOri+"' "+CRLF
		cQry += "AND SB2.B2_COD = SB1.B1_COD "+CRLF
		cQry += "AND SB2.B2_QATU > 0"+CRLF		// cQry += "ORDER BY SD2.D2_COD"
	EndIF

	cQry := ChangeQuery(cQry)
	SqlToTrb( cQry, aFields, 'TRB' )

	TCSetField( 'TRB', 'TRB_CANTID'	, 'N',TamSX3("B2_QATU")[1], 2 )
	TCSetField( 'TRB', 'TRB_VALID'	, 'D',8, 2 )

	("TRB")->(DbGoTop())

	While ("TRB")->(!Eof())
		nSaldoAux	:= 0

		IF !Empty(cUbicOri)
			nSaldoAux := BuSaldo( TRB->TRB_PRODUC, TRB->TRB_LOCAL, TRB->TRB_LOCALI, TRB->TRB_LOTE )
		Else
			nSaldoAux := BuSaldo( TRB->TRB_PRODUC, TRB->TRB_LOCAL, " ", TRB->TRB_LOTE )
		EndIF
	
		// Solo copio los registros que tienen saldo.
		IF nSaldoAux > 0
			IF !Empty(TRB->TRB_LOCALI)
				AADD(aColsTRB,{.F.,;
									TRB->TRB_PRODUC,;
									TRB->TRB_DESCRI,;
									nSaldoAux,;	// nSaldoAux,;		//
									TRB->TRB_UM,;
									TRB->TRB_LOCAL,;
									TRB->TRB_LOCALI,;
									TRB->TRB_LOTE,;
									TRB->TRB_DTVALI})
			Else
				//aProdSBF := BuDatSBF(TRB->TRB_PRODUC, TRB->TRB_LOCAL)
				
				//For nI := 1 To Len(aProdSBF)
					AADD(aColsTRB,{.F.,;
						TRB->TRB_PRODUC,;
						TRB->TRB_DESCRI,;
						TRB->TRB_CANTID,;	// nSaldoAux,;		//
						TRB->TRB_UM,;
						TRB->TRB_LOCAL,;
						TRB->TRB_LOCALI,;
						TRB->TRB_LOTE,;
						TRB->TRB_DTVALI})
				//Next nI
			EndIF
		EndIF

		DbSelectArea("TRB")
		dbSkip()
	EndDo

	IF Len(aColsTRB) == 0
		MsgInfo("No hay datos para visualizar.")
		Return nil
	EndIF

	u_ARGEN2MB(aColsTRB)

//	DbUnlockAll()
	DbSelectArea( 'TRB' )
	DbCloseArea()

Return NIL


/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	BUDATSBF	|	FECHA:	09/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Busco los datos sobre la SBF.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function BuDatSBF(cProdSBF, cDepoSBF)
Local aArea		:= GetArea()
Local aAreaSBF	:= SBF->(GetArea())
Local cAliaSBF	:= GetNextAlias()
Local cQry 		:= ""
Local aRet		:= {}
Local cDescProd := ""
Local cUM		:= ""

	IF Select(cAliaSBF) > 0
		DbSelectArea(cAliaSBF)
		DbCloseArea()
	Endif

	cQry := "SELECT BF_PRODUTO PRODUCTO, (BF_QUANT  - BF_EMPENHO) CANTIDAD, "
	cQry += "BF_LOCAL DEPOSITO, BF_LOCALIZ UBICACION, BF_LOTECTL LOTESBF, "
	cQry += "BF_DATAVEN FECVALI "	
	cQry += "FROM "+RetSqlName("SBF")+" SBF "+CRLF
	cQry += "WHERE D_E_L_E_T_ <> '*' "+CRLF
	cQry += "AND BF_FILIAL = '"+xFilial("SBF")+"' "+CRLF
	cQry += "AND BF_PRODUTO = '"+cProdSBF+"' "+CRLF
	cQry += "AND BF_LOCAL 	= '"+cDepoSBF+"' "+CRLF

	cQry := ChangeQuery(cQry)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), cAliaSBF, .F., .T.)

	DbSelectArea(cAliaSBF)
	DbGoTop()

	WHILE (cAliaSBF)->(!Eof())
		cDescProd:= AllTrim(Posicione("SB1",1,xFilial("SB1") + (cAliaSBF)->PRODUCTO, "B1_DESC"))
		cUM		:= AllTrim(Posicione("SB1",1,xFilial("SB1") + (cAliaSBF)->PRODUCTO, "B1_UM"))
		
		AADD(aRet,{	(	cAliaSBF)->PRODUCTO,;
						cDescProd,;
						(cAliaSBF)->CANTIDAD,;
						cUM,;
						(cAliaSBF)->DEPOSITO,;
						(cAliaSBF)->UBICACION,;
						(cAliaSBF)->LOTESBF,;
						(cAliaSBF)->FECVALI})
		(cAliaSBF)->(DbSkip())
	EndDo

	IF Select(cAliaSBF) > 0
		DbSelectArea(cAliaSBF)
		DbCloseArea()
	Endif

RestArea(aAreaSBF)
RestArea(aArea)

	
Return aRet

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	TudoOk	|	FECHA:	09/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Realizo las validaciones de Tudo Ok.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function TudoOk()
Local nHnd

	If Empty( cFile )
		Aviso("Archivo", "Informe la ruta y el nombre del archivo a procesar.", {"Ok"}, 1 )
		Return( .F. )
	EndIf

	If !File( Alltrim( cFile ) )
		Aviso("Falla de Apertura", "El archivo no existe.", {"Ok"}, 1 )
		Return( .F. )
	EndIf

	nOpa := 1

Return( .T. )

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	AGEN02PA	|	FECHA:	09/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Proceso el archivo con extenciï¿½n CSV.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function AGEN02PA()
Local aArea		:= GetArea()
Local nReg		:= 0
Local nLenField := 0
Local cString 	:= ""
Local cLog		:= ""
Local cFileLog	:= ""
Local cPath		:= ""
Local aVals 	:= {}
Local lCopio	:= .T.

	AutoGrLog( "Fecha Inicio.......: " + Dtoc(MsDate()) )
	AutoGrLog( "Hora Inicio........: " + Time() )
	AutoGrLog( "Environment........: " + GetEnvServer() )
	AutoGrLog( "Empresa / Sucural..: " + SM0->M0_CODIGO + "/" + SM0->M0_CODFIL )
	AutoGrLog( "Razon Social.......: " + Capital( Trim( SM0->M0_NOME) ) )
	AutoGrLog( "Usuario............: " + SubStr( cUsuario, 7, 15 ) )
	AutoGrLog( "Archivo............: " + Alltrim( Lower( cFile ) ) )
	AutoGrLog( " " )

	ProcRegua(400)

	nHndDIE  := FOpen( Alltrim( Lower( cFile ) ) )	// Abro el archivo.

	If nHndDIE == -1
		Aviso("Falla de Apertura", "Hubo una falla en la apertura del archivo.", {"Ok"}, 1 )
		Return( .F. )
	EndIf

	FT_FUSE( cFile )
	FT_FGOTOP( )	// Me paro en el primer registro.

	While !FT_FEOF( )
		lCopio := .T.
		IncProc( 'Procesando Archivo' )
		nReg++

		cString := FT_FREADLN( )
//		AADD(aColsTRB,StrArray( cString,';'))
		aVals := StrArray( cString,';')
		nLenField := Len( aVals )
		cLog      := ''

		IF Empty(aVals[PRODARCH])
			cLog  := 'Registro ' + Alltrim( Str( nReg ) ) + ' el producto no existe.'
			AutoGrLog( cLog )
			lCopio := .F.
		EndIF

		IF Val(aVals[CANTARCH]) <= 0
			cLog  := 'Registro ' + Alltrim( Str( nReg ) ) + ' con cantidad en cero.'
			AutoGrLog( cLog )
			lCopio := .F.
		EndIF

		IF Empty(aVals[DEPOARCH])
			cLog  := 'Registro ' + Alltrim( Str( nReg ) ) + ' el deposito esta vacio.'
			AutoGrLog( cLog )
			lCopio := .F.
		Else		
			//lCopio := ExistCpo("ZZ1", aVals[DEPOARCH])
			// Realizo las validaciones de archivo.
			//lCopio := u_ARGEN2VA(aVals[DEPOARCH], "", 1)
			
			//IF !lCopio
			//	cLog  := 'Registro ' + Alltrim( Str( nReg ) ) + ' el deposito no existe.'
			//	AutoGrLog( cLog )
			//EndIF
		EndIF

		IF Empty(aVals[UBIARCH])
			//cLog  := 'Registro ' + Alltrim( Str( nReg ) ) + ' la ubicacion esta vacia.'
			//AutoGrLog( cLog )
			//lCopio := .F.
		Else
			// Realizo las validaciones de archivo.
			lCopio := .T.//u_ARGEN2VA(aVals[DEPOARCH], aVals[UBIARCH], 2)

			IF !lCopio
				cLog  := 'Registro ' + Alltrim( Str( nReg ) ) + ' la ubicacion no existe.'
				AutoGrLog( cLog )
			EndIF
		EndIF

		// INICIO -  M&H - 14/05/2014
//		IF Empty(aVals[LOTEARCH])
		IF Rastro(aVals[PRODARCH], 'L')	// Si el producto tiene LOTE
			IF Empty(aVals[LOTEARCH])	// Si el lote esta vacio.
				cLog  := 'Registro ' + Alltrim( Str( nReg ) ) + ' el lote esta vacio.'
				AutoGrLog( cLog )
				lCopio := .F.
			EndIF
		EndIF
		// FIN -  M&H - 14/05/2014

		IF lCopio
			// Valido que existan la ubicacion, deposito y producto en las tablas SBF y SB2.
			lCopio := .T.//u_ARGEN2AD(aVals[UBIARCH], aVals[DEPOARCH], aVals[PRODARCH])
		EndIF

		IF lCopio
			AADD(aColsTRB,aVals)
		EndIF

   		FT_FSKIP( )

	EndDo

	FClose( nHndDIE )	// Cierro el archivo

	AutoGrLog( "  " )
	AutoGrLog( "Fecha Fin..........: " + Dtoc(MsDate()) )
	AutoGrLog( "Hora Fin...........: " + Time() )

	cFileLog := NomeAutoLog()

	If cFileLog <> ""
	   nX := 1
	   While .t.
    	  If File( Lower( '\interlog\' + Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
        	 nX++
	         If nX == 999
    	        Exit
        	 EndIf
	         Loop
    	  Else
        	 Exit
	      EndIf
	   EndDo
	   __CopyFile( cPath + Alltrim( cFileLog ), Lower( '\interlog\' + Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
	   MostraErro(cPath,cFileLog)
	   FErase( cFileLog )
	Endif

	IF Len(aColsTRB) == 0
		Alert("No hay datos para visualizar!")
		Return
	EndIF

	u_ARGEN2MB(aColsTRB)

//	DbUnlockAll()
//	DbCloseArea()

RestArea(aArea)

Return

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	StrArray	|	FECHA:	09/04/2014 	|	AUTOR:	 M&H	|	
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Leo el String, separo por campos y lo guardo en un array.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function StrArray( cString, cSep )
Local	aReturn := { },;
		aHeadRet:= { },;
		aRet	:= { },;
      	cAux    := cString,;
      	nPos    := 0
Local cDescCod	:= ""
Local cUM		:= ""
Local nX  := 1         
Local dDtValid


	aHeadRet := {	'aFlag'			,;
					'aProducto'		,;		// 1
					'aDescripcion'	,;		// 2
					'aCantidad'		,;		// 3
					'aUM'			,;		// 4
					'aDeposOri'		,;		// 5
					'aUbicaOri'		,;		// 6
					'aLoteOri'		,;		// 7
					'aFechVenc'}			// 8

	While At( cSep, cAux ) > 0
		nPos  := At( cSep, cAux )
		cVal  := SubStr( cAux, 1, nPos-1 )
		Aadd( aReturn,  cVal )
		cAux  := SubStr( cAux, nPos+1 )
	EndDo

	Aadd( aReturn, cAux )

	For nX := 1 To Len(aHeadRet)
		IF aHeadRet[nX] == 'aFlag'
			AADD(aRet, .F.)
		EndIF
		IF aHeadRet[nX] == 'aProducto'
			AADD(aRet, PADR(aReturn[1], Len(SD3->D3_COD)))
		EndIF
		IF aHeadRet[nX] == 'aDescripcion'
			cDescCod := AllTrim(Posicione("SB1",1,xfilial("SB1")+aReturn[1],"B1_DESC"))
			AADD(aRet, PADR(cDescCod, Len(SB1->B1_DESC)))
		EndIF
		IF aHeadRet[nX] == 'aCantidad'
			AADD(aRet, aReturn[3])
		EndIF
		IF aHeadRet[nX] == 'aUM'
			cUM := AllTrim(Posicione("SB1",1,xfilial("SB1")+aReturn[1],"B1_UM"))
			AADD(aRet, PADR(cUM, Len(SB1->B1_UM)))
		EndIF
		IF aHeadRet[nX] == 'aDeposOri'
			AADD(aRet, PADR(aReturn[4], Len(SD3->D3_LOCAL)))
		EndIF
		IF aHeadRet[nX] == 'aUbicaOri'
			AADD(aRet, "")//PADR(aReturn[5], Len(SD3->D3_LOCALIZ)))
		EndIF
		IF aHeadRet[nX] == 'aLoteOri'
			AADD(aRet, "")//PADR(aReturn[2], Len(SD3->D3_LOTECTL)))
		EndIF
		IF aHeadRet[nX] == 'aFechVenc'    

  			//D5_FILIAL+D5_NUMLOTE+D5_PRODUTO                                                                                                                                 
            DBSelectArea("SB8")
            DBSetOrder(3)
            //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)                                                                                            
            IF DBSeek(xFilial("SB8")+ aRet[2] +aRet[6]+aRet[8])   
	            dDtValid:= dtos(SB8->B8_DTVALID	)
	            AADD(aRet, dDtValid)		
			ELSE				
			AADD(aRet, '  /  /  ')
			ENDIF	
			
		EndIF
	Next nX

	aReturn := aClone(aRet)

	For nX := 1 To Len( aReturn )
		IF ValType(aReturn[nX]) != 'L'
			aReturn[nX] := StrTran( aReturn[nX], '"', '' )
		EndIF
	Next

Return( aReturn )

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGEN02V	|	FECHA:	10/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Realizo validaciones de la pantalla.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function ARGEN02V(cDoc)
Local aArea	:= GetArea()
Local lRet := .T.
Local cQry := ""
Local TMP_DOC := GetNextAlias()
Local nCantDoc := 0
Local cSerAux := ""
Local ClieAux := ""
Local cLojAux := ""
Local lContinue := .F.

	IF Empty(cDoc)
		Alert("El documento es obligatorio.")
		lRet := .F.
	EndIF

	IF Select(TMP_DOC) > 0
		DbSelectArea(TMP_DOC)
		DbCloseArea()
	Endif

	IF lRet
		IF cEspAux $ cSD2Espe
			IF AllTrim(SF2->F2_DOC) != AllTrim(cDoc)
				lContinue := .T.
			EndIF
		Else
			IF cEspAux $ cSD1Espe
				IF AllTrim(SF1->F1_DOC) != AllTrim(cDoc)
					lContinue := .T.
				EndIF
			Else
				// SD3
				RestArea(aArea)
				Return lRet
			EndIF
		EndIF

		IF lContinue
			IF cEspAux $ cSD2Espe
				cQry := "SELECT F2_SERIE SERIEDOC, F2_CLIENTE CLIEFOR, F2_LOJA LOJADOC "
				cQry += "FROM "+RetSqlName("SF2")+" SF2 "+CRLF
				cQry += "WHERE D_E_L_E_T_ <> '*' "+CRLF
				cQry += "AND F2_FILIAL = '"+xFilial("SF2")+"'"+CRLF
				cQry += "AND F2_DOC = '"+cDoc+"'"+CRLF
				cQry += "AND F2_ESPECIE = '"+cEspAux+"'"+CRLF
			Else
				IF cEspAux $ cSD1Espe
					cQry := "SELECT F1_SERIE SERIEDOC, F1_FORNECE CLIEFOR, F1_LOJA LOJADOC"
					cQry += "FROM "+RetSqlName("SF1")+" SF1 "+CRLF
					cQry += "WHERE D_E_L_E_T_ <> '*' "+CRLF
					cQry += "AND F1_FILIAL = '"+xFilial("SF1")+"'"+CRLF
					cQry += "AND F1_DOC = '"+cDoc+"'"+CRLF
					cQry += "AND F1_ESPECIE = '"+cEspAux+"'"+CRLF
				Else
					// SD3
					RestArea(aArea)
					Return lRet
				EndIF
			EndIF

			cQry := ChangeQuery(cQry)
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), TMP_DOC, .F., .T.)

			DbSelectArea(TMP_DOC)
			DbGoTop()

			WHILE (TMP_DOC)->(!Eof())
				nCantDoc++
				cSerAux := (TMP_DOC)->SERIEDOC
				cClieAux := (TMP_DOC)->CLIEFOR
				cLojAux := (TMP_DOC)->LOJADOC
				(TMP_DOC)->(DbSkip())
			EndDo

			IF nCantDoc == 0
				Alert("Documento: "+cDoc+" no existe para la Especie: "+cEspAux)
				lRet := .F.
			EndIF
		
			IF nCantDoc == 1
				cSerie := cSerAux
				cCliente:= cClieAux
				cLoja	:= cLojAux
			EndIF
		
			IF nCantDoc > 1
				Alert("Hay mï¿½s de una coincidencia para el Documento: "+cDoc+" y la Especie: "+cEspAux+" Seleccionada, utilice la consulta standard.")
				lRet := .F.
			EndIF
		Else
			IF cEspAux $ cSD2Espe
	  			cSerie := SF2->F2_SERIE
				cCliente:= SF2->F2_CLIENTE
				cLoja	:= SF2->F2_LOJA
		   	Else
	    		IF cEspAux $ cSD1Espe
   					cSerie := SF1->F1_SERIE
					cCliente:= SF1->F1_FORNECE
					cLoja	:= SF1->F1_LOJA
				Else
					IF Select(TMP_DOC) > 0
						DbSelectArea(TMP_DOC)
						DbCloseArea()
					Endif
					// SD3
					RestArea(aArea)
					Return lRet
				EndIF
			EndIF
		EndIF
	EndIF          

	IF Select(TMP_DOC) > 0
		DbSelectArea(TMP_DOC)
		DbCloseArea()
	Endif

RestArea(aArea)

Return lRet

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	VALIDOACOLS	|	FECHA:	08/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Realizo validaciones de aCols.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function ValidoaCols()
Local nI := 0
Local lRet	:= .T.

	FOR nI := 1 To Len(aCols)
		IF !aCols[nI, Len(aHeader)+1]	// No tengo en cuenta los borrados.
			IF !Empty(aCols[nI][1])
				//Alert("Existen datos en la grilla.")
				//lRet := .F.
				Return lRet
			EndIF
		EndIF
	Next nI
	
Return lRet

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ValidoLote	|	FECHA:	11/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Valido que exista el lote.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function ValidoLote(cProdTmp, cLocalTmp, cLoteTmp, nPosSB8)
Local aArea		:= GetArea()
Local aAreaSB8	:= SB8->(GetArea())
Local lRet		:= .T.
Local cCondic	:= ""
Local lRastro	:= .F.
Local lRastroS	:= .F.
Local cLoteSB8	:= ""
Local cProdSB8	:= ""
Local cLocalSB8 := ""
Local nSaldoSB8	:= 0
Local cAlias	:=""
Local cLog		:= ""

	cLoteSB8	:= Padr(cLoteTmp,Len(SB8->B8_LOTECTL))
	cProdSB8	:= Padr(cProdTmp,Len(SB8->B8_PRODUTO))
	cLocalSB8	:= Padr(cLocalTmp,Len(SB8->B8_LOCAL))

	cAlias := Alias()

	IF Empty(cAlias)
		dbSelectArea("SB8")
	EndIF

	lRastro	:= Rastro(cProdSB8)
	lRastroS:= Rastro(cProdSB8, 'S')

	IF lRastro	// Si el producto usa Rastro
		DbSelectArea("SB8")
		DbSetOrder(3)
		IF SB8->(dbSeek(xFilial('SB8') + cProdSB8 + cLocalSB8 + cLoteSB8 ))
			While !SB8->(Eof()) .And. xFilial('SB8') + cProdSB8 + cLocalSB8 + cLoteSB8 + If(lRastroS,SB8->B8_NUMLOTE,'') == SB8->B8_FILIAL + SB8->B8_PRODUTO + SB8->B8_LOCAL + SB8->B8_LOTECTL + IF(lRastroS, SB8->B8_NUMLOTE,'') .AND. lRet
				nSaldoSB8 += ( SB8->B8_SALDO - SB8->B8_EMPENHO - SB8->B8_QACLASS )

				dFecAux := SB8->B8_DTVALID

				SB8->(dbSkip())
			EndDo
	
			IF nSaldoSB8 <= 0	// Si no tiene saldo.
				lRet := .F.
				cLog  := 'Registro ' + Alltrim( Str( nPosSB8 ) ) + ' El lote: '+cLoteSB8+' para el producto: '+cProdSB8+' y el Deposito: '+cLocalSB8+' no tiene saldo positivo. (SB8).'
				AutoGrLog( cLog )
			Else
				lRet := .T.
			EndIF
		Else
			lRet := .F.	// Si no existe esta dado de alta.
			cLog  := 'Registro ' + Alltrim( Str( nPosSB8 ) ) + ' El lote: '+cLoteSB8+' para el producto: '+cProdSB8+' y el Deposito: '+cLocalSB8+' no existe (SB8).'
			AutoGrLog( cLog )
		EndIF
	Else
		lRet := .T.
	EndIF

RestArea(aAreaSB8)
RestArea(aArea)

Return lRet



Static Function BuRastro(cProd, cTipo)
Local lUsaLote := SuperGetMV("MV_RASTRO") == "S"
Local lRet     := .F.
Local lRetPE   := .F.
Local cAlias   :="",nRecno := 0,nOrder := 0

Static lTestLot := Existblock("TESTLOT")

cTipo:=If(cTipo == NIL,"",cTipo)

If lUsaLote
	If (SB1->(B1_FILIAL+B1_COD) == xFilial("SB1")+cProd)
		lRet := If( Empty(cTipo),(SB1->B1_RASTRO $ "SL" ),(SB1->B1_RASTRO $ cTipo) )
		If lTestLot
			lRetPE:= Execblock("TESTLOT",.F.,.F.)
			If ValType(lRetPE) == "L"
				lRet := lRetPE
			EndIf
		Endif
	Else
		cAlias := Alias()
		If cAlias # "SB1"
			dbSelectArea("SB1")
		EndIf
		nRecno := Recno()
		nOrder := IndexOrd()
		If nOrder # 1
			dbSetOrder(1)
		EndIf
		If MsSeek(xFilial("SB1")+cProd,.F.)
			lRet := If( Empty(cTipo),(SB1->B1_RASTRO $ "SL" ),(SB1->B1_RASTRO $ cTipo) )
		EndIf
		If lTestLot
			lRetPE:= Execblock("TESTLOT",.F.,.F.)
			If ValType(lRetPE) == "L"
				lRet := lRetPE
			EndIf
		Endif	
		If nRecno # Recno()
			dbGoto(nRecno)
		EndIf
		If nOrder # IndexOrd()
			dbSetOrder(nOrder)
		EndIf
		If cAlias # "SB1"
			dbSelectArea(cAlias)
		EndIf
	EndIf
EndIf

Return(lRet)


/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGE02LOTE	|	FECHA:	14/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Validacion referente al campo de Lote
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function ARGE02LOTE(nTipo)
Local nPosL      := 0
Local aArea      := { Alias(), IndexOrd(), Recno() }
Local aSB8Area   := { 'SB8', SB8->(IndexOrd()), SB8->(Recno()) }
Local lRet       := .T.
Local lContinua	 := .T.
Local cVar	     := 'M->D3_LOTECTL'
//Local cCont      := &(ReadVar())
Local cCodProd   := If((nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_COD'    }))>0,aCols[n, nPosL],'')
Local cLocOrig   := If((nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_LOCAL'  }))>0,aCols[n, nPosL],'')
Local cLoteCTL   := If((nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_LOTECTL'}))>0,aCols[n, nPosL],'')
Local cNumLote   := If((nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_NUMLOTE'}))>0,aCols[n, nPosL],'')
Local cCodDest	 := If((nPosL := aScan(aHeader, {|x| x[1] == "Prod.Destino" }))>0,aCols[n, nPosL],'')
Local cLocDest   := If((nPosL := aScan(aHeader, {|x| x[1] == "Deposito Destino" }))>0,aCols[n, nPosL],'')

Local cCont      := IF((nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_LOTECTL'}))>0,aCols[n, nPosL],'')

Local nPosDtVldD := aScan(aHeader, {|x| x[1]=="Validad Destino" })
Local lRastroL   := Rastro(cCodProd, 'L')
Local lRastroS   := Rastro(cCodProd, 'S')
Local lRastroD	 := Rastro(cCodProd)

Default nTipo	 := 1

//-- Sï¿½ Permite Lote ou SubLote
If cVar # 'M->D3_LOTECTL' .And. cVar # 'M->D3_NUMLOTE'
	lContinua := .F.
Else
	cLoteCTL := If(cVar=='M->D3_LOTECTL',cCont,cLoteCTL)
	cNumLote := If(cVar=='M->D3_NUMLOTE',cCont,cNumLote)
	IF Empty(cLoteCTL)
		lContinua := .F.
	EndIF
EndIf
If lContinua
	If nTipo == 1
		//-- O campo Lote sempre deve estar preenchido
		If (lRastroL .Or. lRastroS) .And. Empty(cLoteCTL)
			Help(' ',1,'MA260LOTE')
			lContinua	:= .F.
			lRet		:= .F.
		EndIf

		//-- Se o Controle for Lote o campo Sub-Lote nao pode ser preenchido
		If lContinua .And. lRastroL .And. cVar == 'M->D3_NUMLOTE' .And. !Empty(cNumLote)
//			&(ReadVar()) := Space(Len(&(ReadVar())))
			lContinua	:= .F.
			lRet		:= .F.
		EndIf

		//-- Se o Sub-Lote nao estiver preenchido, Valida somente o Lote.
		If lContinua .And. lRastroS .And. cVar == 'M->D3_LOTECTL' .And. Empty(cNumLote)
			lRastroL := .T.
			lRastroS := .F.
		EndIf

		If lContinua
			If lRastroL //-- Validacao de Lote
				SB8->(dbSetOrder(3))
				If SB8->(dbSeek(xFilial('SB8') + cCodProd + cLocOrig + cLoteCTL, .F.)) .AND. (dA261Data >= SB8->B8_DATA)
					nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_DTVALID'})
					If nPosL > 0
						aCols[n,nPosL] := SB8->B8_DTVALID
					EndIf
					nPosL := aScan(aHeader, {|x| x[1]=="Validad Destino"})
					If nPosL > 0
						aCols[n,nPosL] := SB8->B8_DTVALID
					EndIf
					nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_POTENCI'})
					If nPosL > 0
						aCols[n,nPosL] := SB8->B8_POTENCI
					EndIf
					If Rastro(cCodProd, 'S')
						nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_NUMLOTE'})
						If nPosL > 0
							aCols[n,nPosL] := SB8->B8_NUMLOTE
						EndIf
					EndIf
					nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_LOTECTL'})
					If nPosL > 0
						aCols[n,nPosL] := SB8->B8_LOTECTL
					EndIf
					nSB8Recno     := SB8->(Recno())
				Else
					If		!SB8->(FOUND())
						Help(' ', 1, 'A240LOTERR')
					Else	// (dEmis260 < SB8->B8_DATA)
						Help(' ',1,"A240LOTDT") //-- Data de origem do lote(B8_DATA) ï¿½ maior que data da inclusï¿½o.
					EndIf
					lContinua	:= .F.
					lRet		:= .F.
				EndIf
			ElseIf lRastroS //-- Validacao de Lote e Sub-Lote
				SB8->(dbSetOrder(2))
				If SB8->(dbSeek(xFilial('SB8') + cNumLote + cLoteCTL + cCodProd + cLocOrig, .F.))
					nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_DTVALID'})
					If nPosL > 0
						aCols[n,nPosL] := SB8->B8_DTVALID
					EndIf
					nPosL := aScan(aHeader, {|x| x[1]=="Validad Destino"})
					If nPosL > 0
						aCols[n,nPosL] := SB8->B8_DTVALID
					EndIf
					nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_POTENCI'})
					If nPosL > 0
						aCols[n,nPosL] := SB8->B8_POTENCI
					EndIf
					If Rastro(cCodProd, 'S')
						nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_NUMLOTE'})
						If nPosL > 0
							aCols[n,nPosL] := SB8->B8_NUMLOTE
						EndIf
					EndIf
					nPosL := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_LOTECTL'})
					If nPosL > 0
						aCols[n,nPosL] := SB8->B8_LOTECTL
					EndIf
					nSB8Recno     := SB8->(Recno())
				Else
					Help(' ', 1, 'A240LOTERR')
					lContinua	:= .F.
					lRet		:= .F.
				EndIf
			Else
//				&(ReadVar()) := Space(Len(&(ReadVar())))
				lContinua	:= .F.
				lRet		:= .T.
			EndIf
		EndIf
	ElseIf nTipo == 2
		If Rastro(cCodDest) .And. !Empty(cCont)
			dbSelectArea("SB8")
			dbSetOrder(3)
			If dbSeek(xFilial("SB8")+cCodDest+cLocDest+cCont) .And. SB8->B8_DTVALID # aCols[n,nPosDtVldD]
				If !Empty(aCols[n,nPosDtVldD])
					HelpAutoma(" ",1,"A240DTVALI",,,,,,,,,.F.)
				EndIf
				aCols[n,nPosDtVldD] := SB8->B8_DTVALID
			ElseIf Empty(aCols[n,nPosDtVldD])
				aCols[n,nPosDtVldD] := dDataBase
			EndIf
		Else
			aCols[n,nPosDtVldD] := CriaVar("D3_DTVALID")
			lRet := .F.
		EndIf
	EndIf
EndIf

//-- Retorna Integridade do Sistema
dbSelectArea(aSB8Area[1]); dbSetOrder(aSB8Area[2]); dbGoto(aSB8Area[3])
dbSelectArea(aArea[1]); dbSetOrder(aArea[2]); dbGoto(aArea[3])

Return lRet

/*
* Busco por la ubicacion, deposito y producto.
*/
User Function ARGEN2AD(cUbicOri, cDeposOri, cProducto)
Local cQryAlias:= GetNextAlias()
Local cQry		:= ""
Local aFields	:= {}
Local aCampos	:= {}
Local lMuestro:= .F.

	IF Select(cQryAlias) > 0
		DbSelectArea(cQryAlias)
		DbCloseArea()
	Endif

	// Busco las ubicaciones
	cQry := "SELECT ' ' TRB_OK, SBF.BF_PRODUTO TRB_PRODUC, SB1.B1_DESC TRB_DESCRI, (SBF.BF_QUANT - SBF.BF_EMPENHO ) TRB_CANTID, "
	cQry += "SB1.B1_UM TRB_UM, SBF.BF_LOCAL TRB_LOCAL, SBF.BF_LOCALIZ TRB_LOCALI, SBF.BF_LOTECTL TRB_LOTE, "
	cQry += "SBF.BF_DATAVEN TRB_DTVALI "	
	cQry += "FROM "+RetSqlName("SBF")+" SBF, "+RetSqlName("SB1")+" SB1 "+CRLF
	cQry += "WHERE SBF.D_E_L_E_T_ <> '*' "+CRLF
	cQry += "AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_MSBLQL <> '1' "+CRLF
	cQry += "AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQry += "AND SBF.BF_FILIAL = '"+xFilial("SBF")+"' "+CRLF
	cQry += "AND SBF.BF_LOCALIZ = '"+cUbicOri+"' "+CRLF
	cQry += "AND SBF.BF_LOCAL = '"+cDeposOri+"' "+CRLF
	cQry += "AND SBF.BF_PRODUTO = '"+cProducto+"' "+CRLF
	cQry += "AND SBF.BF_PRODUTO = SB1.B1_COD "+CRLF
	cQry += "AND ( SBF.BF_QUANT - SBF.BF_EMPENHO ) > 0"+CRLF
/**
	cQry += "UNION "

	// Busco los depositos
	cQry += "SELECT ' ' TRB_OK, SB2.B2_COD TRB_PRODUC, SB1.B1_DESC TRB_DESCRI, SB2.B2_QATU TRB_CANTID, "
	cQry += "SB1.B1_UM TRB_UM, SB2.B2_LOCAL TRB_LOCAL, ' ' TRB_LOCALI, ' ' TRB_LOTE, "
	cQry += "' ' TRB_DTVALI "
	cQry += "FROM "+RetSqlName("SB2")+" SB2, "+RetSqlName("SB1")+" SB1 "+CRLF
	cQry += "WHERE SB2.D_E_L_E_T_ <> '*' "+CRLF
	cQry += "AND SB1.D_E_L_E_T_ <> '*' "+CRLF
	cQry += "AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQry += "AND SB2.B2_FILIAL = '"+xFilial("SB2")+"' "+CRLF
	cQry += "AND SB2.B2_LOCAL = '"+cDeposOri+"' "+CRLF
	cQry += "AND SB2.B2_COD = '"+cProducto+"' "+CRLF
	cQry += "AND SB2.B2_COD = SB1.B1_COD "+CRLF
	cQry += "AND SB2.B2_QATU > 0"+CRLF
**/
	cQry := ChangeQuery(cQry)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), cQryAlias, .F., .T.)

	DbSelectArea(cQryAlias)
	DbGoTop()

	IF (cQryAlias)->(!Eof())
		lMuestro:= .T.
	EndIF

	IF Select(cQryAlias) > 0
		DbSelectArea(cQryAlias)
		DbCloseArea()
	Endif

Return lMuestro

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGEN2EB	|	FECHA:	10/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Adiciona botones en el EnchoiceBar.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function ARGEN2EB()
Local aArea	:= GetArea()
Local aRet	:= {}

	IF isincallstack("MATA261") .AND. INCLUI
		Aadd(aRet ,{"DOCUMENTO.PNG"	,	{|| u_ARGEN002(1) }	, "Importo mediante el Documento" , "Documentos" })
		//Aadd(aRet ,{"DEPOSITO.PNG"	,	{|| u_ARGEN002(2) }	, "Importo mediante el Depï¿½sito y la Ubicaciï¿½n" , "Depï¿½sitos" })
		//Aadd(aRet ,{"ARCHIVO.PNG"	,	{|| u_ARGEN002(3) }	, "Importo mediante un Archivo CSV" , "Archivo" })
	Endif

RestArea(aArea)

Return aRet

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGE02DS	|	FECHA:	08/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Filtro para los documentos de salida.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function ARGE02DS()
Local cRet		:= ""
Local cSF2Espe:= BuEspecie(cGenera)

	cRet :=  "SF2->F2_FILIAL==xFilial('SF2') .AND. SF2->F2_ESPECIE = '"+cSF2Espe+"' "

Return cRet

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGE02DE	|	FECHA:	08/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Filtro para los documentos de entrada.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function ARGE02DE()
Local cRet		:= ""
Local cSF1Espe:= BuEspecie(cGenera)

	cRet :=  "SF1->F1_FILIAL==xFilial('SF1') .AND. SF1->F1_ESPECIE = '"+cSF1Espe+"' "

Return cRet

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGE02D3	|	FECHA:	08/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Filtro para los documentos de movimientos internos.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function ARGE02D3()
Local cRet := ""

	cRet :=  "SD3->D3_FILIAL==xFilial('SD3')"

Return cRet

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGEN2VA	|	FECHA:	14/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Valido el archivo.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function ARGEN2VA(cDeposito, cUbicaci, nOpcAcsv)
Local aArea := GetArea()
Local aAreaZZ1 := ZZ1->(GetArea())
Local aAreaSBE := SBE->(GetArea())
Local lRet := .T.

	IF nOpcAcsv == 1
		DbSelectArea("ZZ1")
		DbSetOrder(1)
		IF !DbSeek(xFilial("ZZ1") + cDeposito )
			lRet := .F.
		EndIF
	EndIF
	
	IF nOpcAcsv == 2
		DbSelectArea("SBE")
		DbSetOrder(1)
		IF !DbSeek(xFilial("SBE")  + cDeposito + cUbicaci)
			lRet := .F.
		EndIF
	EndIF

RestArea(aAreaSBE)
RestArea(aAreaZZ1)
RestArea(aArea)

Return lRet

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	ARGEN2VP	|	FECHA:	14/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Valido las preguntas.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
User Function ARGEN2VP(cAliasP, nOpP)
Local lRet := .T.
	
	IF nOpP == 1 .AND. !Empty(MV_PAR01)
		lRet := ExistCpo(cAliasP, MV_PAR01)
	EndIF

	IF nOpP == 2 .AND. !Empty(MV_PAR01) .AND. !Empty(MV_PAR02)
		lRet := ExistCpo(cAliasP, MV_PAR01 + MV_PAR02)
	EndIF

	IF nOpP == 3 .AND. !Empty(MV_PAR03)
		lRet := ExistCpo(cAliasP, MV_PAR03)
	EndIF

	IF nOpP == 4 .AND. !Empty(MV_PAR03) .AND. !Empty(MV_PAR04)
		lRet := ExistCpo(cAliasP, MV_PAR03 + MV_PAR04)
	EndIF

Return lRet

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
PROGRAMA: 	ARGEN002	|	FUNCION:	AjustaSX1	|	FECHA:	03/04/2014 	|	AUTOR:	 M&H	|	 
--------------------------------------------------------------------------------------------------------------------------------------------------
DESCRIPCION: Genero las preguntas segun la opcion elegida.
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/
Static Function AjustaSX1(cPerg)
Local aArea := GetArea()
Local aRegs := {}, i, j

cPerg := Padr(cPerg,Len(SX1->X1_GRUPO))

DbSelectArea("SX1")
DbSetOrder(1)

	IF cPerg == Padr("ARGEN02A",Len(SX1->X1_GRUPO))	// Preguntas de Archivo.
		AADD(aRegs,{cPerg,"01","Deposito dest"			,"Deposito dest"		,"Deposito dest"		,"mv_ch1","C",02,0,0,"G","u_ARGEN2VP('NNR', 1)"	,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","NNR","","" } )
		AADD(aRegs,{cPerg,"02","Ubicacion dest"			,"Ubicacion dest"		,"Ubicacion dest"		,"mv_ch2","C",15,0,0,"G","u_ARGEN2VP('SBE', 2)"	,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SBE","","" } )
		AADD(aRegs,{cPerg,"03","Archivo Importar?"	,"Archivo Importar?","Archivo Importar?","mv_ch3","C",60,0,0,"G","U_ARGE2I"	,"MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	EndIF

	IF cPerg == Padr("ARGEN02U",Len(SX1->X1_GRUPO))	// Preguntas de Ubicacion y Deposito.
		AADD(aRegs,{cPerg,"01","Deposito orig"	,"Deposito orig"	,"Deposito orig"	,"mv_ch1","C",02,0,0,"G","u_ARGEN2VP('NNR', 1)","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","NNR","","" } )
		AADD(aRegs,{cPerg,"02","Ubicacion orig"	,"Ubicacion orig"	,"Ubicacion orig"	,"mv_ch2","C",15,0,0,"G","u_ARGEN2VP('SBE', 2)","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SBE","","" } )
		AADD(aRegs,{cPerg,"03","Deposito dest"	,"Deposito dest"	,"Deposito dest"	,"mv_ch3","C",02,0,0,"G","u_ARGEN2VP('NNR', 3)","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","NNR","","" } )
		AADD(aRegs,{cPerg,"04","Ubicacion dest"	,"Ubicacion dest"	,"Ubicacion dest"	,"mv_ch4","C",15,0,0,"G","u_ARGEN2VP('SBE', 4)","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SBE","","" } )
	EndIF

	For i:=1 to Len(aRegs)
   		If !dbSeek(cPerg+aRegs[i,2])
      		RecLock("SX1",.T.)
      		For j:=1 to FCount()
         		If j <= Len(aRegs[i])
         			FieldPut(j,aRegs[i,j])
         		Endif
      		Next
			MsUnlock()
		Endif
	Next

	RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FindArq   ºAutor  ³Microsiga           º Data ³  06/27/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FindArq(oListArq,aListArq)
Local oDlgSeek
Local cSeek := Space(20)
Local lCase := .F.
Local lWord := .F.
Local nLastSeek := 0
Local cLastSeek := ""
Local nPos := oListArq:nAt
Local aSeek := {}

Aeval(aListArq,{|x,y| Aadd(aSeek,x[2])})

DEFINE MSDIALOG oDlgSeek FROM 00,00 TO 105,370 TITLE OemtoAnsi("Pesquisar") PIXEL   

@07,02 SAY OemToAnsi("Buscar")+":" OF oDlgSeek PIXEL 
@05,30 GET cSeek OF oDlgSeek PIXEL SIZE 100,9

@20,02 TO 51,130 LABEL OemtoAnsi("Opciones") PIXEL OF oDlgSeek 
@27,05 CHECKBOX lCase PROMPT OemtoAnsi("&Coincidir mayusc./minúsc.") FONT oDlgSeek:oFont PIXEL SIZE 80,09 
@38,05 CHECKBOX lWord PROMPT OemtoAnsi("Localizar palabra entera") FONT oDlgSeek:oFont PIXEL SIZE 80,09 

@05,135 BUTTON OemtoAnsi("&Próximo") PIXEL OF oDlgSeek SIZE 44,11; 
ACTION (nPos := FastSeek(cSeek,nPos,aSeek,lCase,lWord),oListArq:nAt := nPos,oListArq:Refresh())

@18,135 BUTTON OemtoAnsi("&Cancelar") PIXEL ACTION oDlgSeek:End() OF oDlgSeek SIZE 44,11 

ACTIVATE MSDIALOG oDlgSeek CENTERED
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FastSeek ºAutor  ³Microsiga           º Data ³  06/27/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FastSeek(cGet,nLastSeek,aArray,lCase,lWord)

Local nSearch := 0
Local bSearch

cGet := Trim(cGet)

If ( lCase .And. lWord )
	bSearch := {|x| Trim(x) == cGet}
ElseIf ( !lCase .And. !lWord )
	bSearch := {|x| Trim(Upper(SubStr(x,1,Len(cGet)))) == Upper(cGet)}
ElseIf ( lCase .And. !lWord )
	bSearch := {|x| Trim(SubStr(x,1,Len(cGet))) == cGet}
ElseIf ( !lCase .And. lWord )
	bSearch := {|x| Trim(Upper(x)) == Upper(cGet)}
EndIf

nSearch := Ascan(aArray,bSearch,nLastSeek+1)
If ( nSearch == 0 )
	nSearch := Ascan(aArray,bSearch)
	If ( nSearch == 0 )
		nSearch := nLastSeek
	EndIf
EndIf

Return nSearch
