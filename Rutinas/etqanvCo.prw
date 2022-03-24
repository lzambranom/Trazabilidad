#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'

*******************************************************************************************************
*******************************************************************************************************
//Função: ETQANV() - Rotina de impressão de Etiqueta Anvisa.                                         //
//                   Recebe parâmetros através do PE SD3250I ou através da Rotina de Menu fEtqAnv    //
*******************************************************************************************************
*******************************************************************************************************
User Function ETQANVCO(cCodProd, dDtaFab, cLotSer)

	Local aArea			:= GetArea()

	fEtqCol(cCodProd, dDtaFab, cLotSer)

	RestArea(aArea)

Return

/*
ETIQUETA COLOMBIA
*/
Static Function fEtqCol(cCodProd, dDtaFab, cLotSer)

	Local cPorta   		:= GetMv("ZZ_PORTA01")
	Local dDtaVenc		:= CTOD("  /  /  ")
	Local nTempo		:= 0
	Local cTipe			:= "NA"
	Local nQtd			:= 1
	Local vigencia		:= CTOD("  /  /  ")

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	dbSeek(xFilial("SB1")+cCodProd)

	posicione('SZ3',1,xFilial('SZ3')+SB1->B1_XINVIMA,'Z3_VIGENCI')

//dDtaVenc:= (dDtaFab + iif(SB1->B1_OBPTGAR = "M", SB1->B1_OBPRGAR*30, iif(SB1->B1_OBPTGAR = "A",SB1->B1_OBPRGAR*365,0)))

	if SB1->B1_TIPE = "N"
		cTipe:= "NA"
	elseif SB1->B1_TIPE = "H"
		cTipe:= if (SB1->B1_PRVALID > 1,"HORAS","HORA")
	elseif SB1->B1_TIPE = "S"
		cTipe:= if (SB1->B1_PRVALID > 1,"SEMANAS","SEMANA")
	elseif SB1->B1_TIPE = "D"
		cTipe:= if (SB1->B1_PRVALID > 1,"DIAS","DIA")
	elseif SB1->B1_TIPE = "M"
		cTipe:= if (SB1->B1_PRVALID > 1,"MESES","MES")
	elseif SB1->B1_TIPE = "A"
		cTipe:= if (SB1->B1_PRVALID > 1,"ANO","ANOS")
	endif

	MSCBPRINTER("S4N",cPorta,,,.f.,,,,,,.t.)
	MSCBCHKSTATUS(.f.)

	MSCBBEGIN(1,6,97)

	MSCBWrite("^XA")
	MSCBWrite("^MMT")
	MSCBWrite("^PW599")
	MSCBWrite("^LL0280")
	MSCBWrite("^LS0")
	MSCBWrite("^FT591,250^A0I,22,24^FH\^FD"+Alltrim(SB1->B1_DESC)+"^FS")
	MSCBWrite("^FT587,184^A0I,14,14^FH\^FDImportado por:^FS")
	MSCBWrite("^FT590,223^A0I,18,16^FH\^FDModelo: "+Alltrim(SB1->B1_COD)+"^FS")
	MSCBWrite("^FT587,164^A0I,14,14^FH\^FDOTTO BOCK HEALTH CARE ANTINA S.A.S^FS")
	MSCBWrite("^FT587,148^A0I,14,14^FH\^FDCARRERA #22 164 - 34, BOGOTA D.C.^FS")
	MSCBWrite("^FT587,131^A0I,14,14^FH\^FDTel\82fono 8619988 - Fax 8610868^FS")
	MSCBWrite("^FT587,114^A0I,14,14^FH\^FDinfo@ottobock.com.co - www.ottobock.com^FS")
	MSCBWrite("^FT587,97^A0I,14,14^FH\^FDREGISTRO SANIT\B5RIO N\A7:^FS")
	MSCBWrite("^FT587,80^A0I,14,14^FH\^FDINVIMA: "+Alltrim(SB1->B1_ZZINVIM)+" "+Alltrim(vigencia)+"^FS")
	MSCBWrite("^FT587,63^A0I,14,14^FH\^FDNIT 830.109.997-9^FS")
	MSCBWrite("^FT39,296^BQN,2,6")
	MSCBWrite("^FDLA,"+Alltrim(SB1->B1_COD)+"|"+Alltrim(cLotSer)+"^FS")
	MSCBWrite("^FT211,68^A0I,17,14^FH\^FDHecho en: "+DTOC(dDtaFab)+"^FS")
	MSCBWrite("^FT211,47^A0I,17,14^FH\^FDNo. Serie/Lote: "+cLotSer+"^FS")
	MSCBWrite("^FT211,27^A0I,17,14^FH\^FDMarca: Ottobock.^FS")
	MSCBWrite("^FO217,12^GB0,259,1^FS")
	MSCBWrite("^FO218,208^GB372,0,1^FS")
	MSCBWrite("^FT212,87^A0I,23,24^FH\^FDContenido: "+Alltrim(STR(nQtd))+"  "+Alltrim(SB1->B1_UM)+"^FS")
	MSCBWrite("^FT587,45^A0I,11,12^FH\^FD"+Alltrim(SB1->B1_ZZINVDE)+"^FS")
	MSCBWrite("^PQ1,0,1,Y^XZ")

	MSCBEND()

	MSCBCLOSEPRINTER()

Return
