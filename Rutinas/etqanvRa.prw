#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'

*******************************************************************************************************
*******************************************************************************************************
//Função: ETQANV() - Rotina de impressão de Etiqueta Anvisa.                                         //
//                   Recebe parâmetros através do PE SD3250I ou através da Rotina de Menu fEtqAnv    //
*******************************************************************************************************
*******************************************************************************************************
User Function ETQANVRA(cCodProd, dDtaFab, cLotSer, cCrea, cNome, nNumEtq, nQtdEtq, cIdioma, dDtaVal,cAutImp,cOBLocal,_cInvim1)

Local aArea			:= GetArea()

if cObLocal = "4" //Mexico
	fEtqMex(cCodProd, dDtaFab, cLotSer, dDtaVal)
elseif cObLocal = "3" //Colombia
	fEtqCol(cCodProd, dDtaFab, cLotSer, _cInvim1)
elseif cObLocal = "2" //Argentina
	fEtqArg(cCodProd, cLotSer, cAutImp)
elseif cObLocal = "1" //Brasil
	fEtqBra(cCodProd, dDtaFab, cLotSer, cCrea, cNome, nNumEtq, nQtdEtq)
endif	

RestArea(aArea)

Return

/*
ETIQUETA MÉXICO
*/
Static Function fEtqMex(cCodProd, dDtaFab, cLotSer, dDtaVal)

Local cPorta   		:= GetMv("ZZ_PORTA01")
Local dDtaVenc		:= CTOD("  /  /  ")
Local nTempo		:= 0
Local cTipe			:= "NA"
Local cUm			:= ""
Local nQtdUn		:= 1


dbSelectArea("SB1")
SB1->(dbSetOrder(1))
dbSeek(xFilial("SB1")+cCodProd)

dbSelectArea("SAH")
SB1->(dbSetOrder(1))
dbSeek(xFilial("SAH")+SB1->B1_UM)


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
elseif SB1->B1_TIPE = "F"
	cTipe:= "DT"
endif	

MSCBPRINTER("S4N",cPorta,,,.f.,,,,,,.t.)
MSCBCHKSTATUS(.f.)
	
MSCBBEGIN(1,6,97)  

MSCBWrite("^XA")
MSCBWrite("^MMT")
MSCBWrite("^PW599")
MSCBWrite("^LL0280")
MSCBWrite("^LS0")
MSCBWrite("^FT591,227^A0I,22,24^FH\^FD"+Alltrim(SB1->B1_DESC)+"^FS")
MSCBWrite("^FT491,140^A0I,17,16^FH\^FDImportado por:^FS")
MSCBWrite("^FT590,172^A0I,18,16^FH\^FDModelo: "+Alltrim(SB1->B1_COD)+"^FS")
MSCBWrite("^FT421,200^A0I,17,16^FH\^FDHecho en: "+Alltrim(SB1->B1_ZZORIFA)+"^FS")
MSCBWrite("^FT590,200^A0I,17,16^FH\^FDMarca: Ottobock. ^FS")
MSCBWrite("^FT555,115^A0I,17,16^FH\^FDOtto bock de M\82xico, S.A. de C.V.^FS")
MSCBWrite("^FT507,21^A0I,17,16^FH\^FDwww.ottobock.com^FS")
MSCBWrite("^FT526,45^A0I,17,16^FH\^FDM\82xico, Tel. 55 52784163^FS")
MSCBWrite("^FT590,69^A0I,17,16^FH\^FDAlvaro Obregon, Ciudad de M\82xico, C.P. 01180,^FS")
MSCBWrite("^FT55,294^BQN,2,6")
MSCBWrite("^FDLA,"+Alltrim(SB1->B1_COD)+"|"+Alltrim(cLotSer)+"^FS")
MSCBWrite("^FT586,92^A0I,17,16^FH\^FDProl. Calle 18 178-A San Pedro de los Pinos,^FS")
MSCBWrite("^FT248,51^A0I,17,14^FH\^FDNo. Serie/Lote: "+cLotSer+"^FS")
if cTipe = "NA
	MSCBWrite("^FT248,30^A0I,17,14^FH\^FDFecha de Caducidad: "+Alltrim(cTipe)+"^FS")
elseif cTipe = "DT"
	MSCBWrite("^FT248,30^A0I,17,14^FH\^FDFecha de Caducidad: "+DTOC(dDtaVal)+"^FS")
else	
	MSCBWrite("^FT248,30^A0I,17,14^FH\^FDFecha de Caducidad: "+Alltrim(STR(SB1->B1_PRVALID ))+"  "+Alltrim(cTipe)+"^FS")
endif	
MSCBWrite("^FO252,12^GB0,259,1^FS")
MSCBWrite("^FO253,162^GB337,0,1^FS")
MSCBWrite("^FT593,261^A0I,17,16^FH\^FDFavor de leer instructivo anexo^FS")
//if Alltrim(SB1->B1_UM) <> "PZ"
	//MSCBWrite("^FT249,74^A0I,28,28^FH\^FDContenido: "+Alltrim(STR(nQtdUn))+"  "+Alltrim(SAH->AH_UMRES)+"^FS")
	MSCBWrite("^FT249,74^A0I,28,28^FH\^FDContenido: "+Alltrim(STR(SB1->B1_QE))+"  "+Alltrim(SAH->AH_UMRES)+"^FS")
//else
//	cUm:= "PZA"
//	MSCBWrite("^FT249,74^A0I,28,28^FH\^FDContenido: "+Alltrim(STR(nQtdUn))+"  "+Alltrim(cUm)+"^FS")
//endif	
MSCBWrite("^PQ1,0,1,Y^XZ")

MSCBEND()

MSCBCLOSEPRINTER()


Return


/*
ETIQUETA BRASIL
*/
Static Function fEtqBra(cCodProd, dDtaFab, cLotSer, cCrea, cNome, nNumEtq, nQtdEtq) 

Local cPorta   		:= GetMv("ZZ_PORTA01")

Local cNomFLegal	:= ""
Local cEndFLegal	:= ""
Local cBairFLegal	:= ""
Local cCepFLegal	:= ""
Local cMunFLegal	:= ""
Local cEstFLegal	:= ""
Local cPaisFLegal	:= ""

Local cNomFNacio	:= ""
Local cEndFNacio	:= ""
Local cBairFNacio	:= ""
Local cCepFNacio	:= ""
Local cMunFNacio	:= ""
Local cEstFNacio	:= ""
Local cTelFNacio	:= ""
Local cCnpjFNacio	:= ""


dbSelectArea("SB1")
SB1->(dbSetOrder(1))
dbSeek(xFilial("SB1")+cCodProd)

//FABRICANTE LEGAL
SA2->(dbSetOrder(1))
if SA2->(dbSeek(xFilial("SA2")+SB1->(B1_ZZFABLE+B1_ZZLFABL)))
	cNomFLegal	:= Alltrim(SA2->A2_ZZNOME)
	cEndFLegal	:= Alltrim(SA2->A2_END)
	cBairFLegal	:= Alltrim(SA2->A2_BAIRRO)
	cCepFLegal	:= Substr(SA2->A2_CEP,1,5) + "-" + Substr(SA2->A2_CEP,6,3)
	cMunFLegal	:= Alltrim(SA2->A2_MUN)
	cEstFLegal	:= Alltrim(SA2->A2_EST)
	cPaisFLegal	:= Alltrim(Posicione("SYA",1,xFilial("SYA") + SA2->A2_PAIS,"YA_DESCR"))
endif	

//FABRICANTE NACIONAL
SA2->(dbSetOrder(1))
if SA2->(dbSeek(xFilial("SA2")+SB1->(B1_ZZFABNA+B1_ZZLFABN)))
	cNomFNacio	:= Alltrim(SA2->A2_ZZNOME)
	cEndFNacio	:= Alltrim(SA2->A2_END)
	cBairFNacio	:= Alltrim(SA2->A2_BAIRRO)
	cCepFNacio	:= Substr(SA2->A2_CEP,1,5) + "-" + Substr(SA2->A2_CEP,6,3)
	cMunFNacio	:= Alltrim(SA2->A2_MUN)
	cEstFNacio	:= Alltrim(SA2->A2_EST)
	cTelFNacio	:= "("+Alltrim(SA2->A2_DDD)+") " + Substr(SA2->A2_TEL,1,4) + "." + Substr(SA2->A2_TEL,5,4)
	cCnpjFNacio	:= Transform(SA2->A2_CGC,"@r 99.999.999/9999-99")
	cPaisFNacio	:= Alltrim(Posicione("SYA",1,xFilial("SYA") + SA2->A2_PAIS,"YA_DESCR"))
endif	



if SB1->B1_OBTPVAL == "D"
	cValidade:= "DIAS"
elseif SB1->B1_OBTPVAL == "S"
	cValidade:= "SEMANAS"	
elseif SB1->B1_OBTPVAL == "M"
	cValidade:= "MESES"
elseif SB1->B1_OBTPVAL == "I"
	cValidade:= "INDETERMINADO"
elseif SB1->B1_OBTPVAL == "V"
	cValidade:= "VIDE EMBALAGEM"
endif		
		
if SB1->B1_OBTPGAR == "M"
	cGarantia:= "MESES"
else
	cGarantia:= "ANOS"
endif			

if Empty(cCrea)
	cNome:=""
endif

MSCBPRINTER("S4N",cPorta,,,.f.,,,,,,.t.)
MSCBCHKSTATUS(.f.)
	
MSCBBEGIN(1,6,97)  

MSCBWrite("^XA")
MSCBWrite("^MMT")
MSCBWrite("^PW831")
MSCBWrite("^LL0713")
MSCBWrite("^LS0")
MSCBWrite("^FT19,39^A0N,23,24^FH\^FDFABRICANTE^FS")
MSCBWrite("^FT415,71^A0N,23,24^FH\^FD"+cNomFNacio+"^FS")
MSCBWrite("^FT19,71^A0N,23,24^FH\^FD"+cNomFLegal+"^FS")
MSCBWrite("^FT415,40^A0N,23,24^FH\^FDDISTRIBUIDOR^FS")
MSCBWrite("^FT414,93^A0N,17,16^FH\^FD"+cEndFNacio+" | "+cBairFNacio+"^FS")
MSCBWrite("^FT414,114^A0N,17,16^FH\^FD"+cCepFNacio+" | "+cMunFNacio+" | "+cEstFNacio+"  | "+cTelFNacio+"^FS")
MSCBWrite("^FT414,135^A0N,17,16^FH\^FDCNPJ: "+cCnpjFNacio+"^FS")
MSCBWrite("^FT18,93^A0N,17,16^FH\^FD"+cEndFLegal+" - "+cCepFLegal+"^FS")
MSCBWrite("^FT18,114^A0N,17,16^FH\^FD"+cMunFLegal+" | "+cPaisFLegal+"^FS")
MSCBWrite("^FT19,183^A0N,28,28^FH\^FD"+Alltrim(SB1->B1_COD)+"^FS")
MSCBWrite("^FT19,244^A0N,28,28^FH\^FDREG. ANVISA: "+Alltrim(SB1->B1_OBCODMS)+"^FS")
MSCBWrite("^FT19,214^A0N,28,28^FH\^FD"+Alltrim(SB1->B1_DESC)+"^FS")
MSCBWrite("^FT20,380^A0N,17,16^FH\^FDGARANTIA: "+Alltrim(STR(SB1->B1_OBPRGAR))+" "+Alltrim(cGarantia)+"^FS")
MSCBWrite("^FT20,435^A0N,17,16^FH\^FDLOTE/N.SERIE: "+Alltrim(cLotSer)+"^FS")
MSCBWrite("^FT20,410^A0N,17,16^FH\^FDCONTEM UM(A): "+Alltrim(SB1->B1_UM)+"^FS")
MSCBWrite("^FT20,357^A0N,17,16^FH\^FDVALIDADE: "+Alltrim(cValidade)+"^FS")
MSCBWrite("^FT19,332^A0N,17,16^FH\^FDFABRICACAO: "+Day2Str(dDtaFab)+"/"+Month2Str(dDtaFab)+"/"+Year2Str(dDtaFab)+"^FS")
// MSCBWrite("^FT19,332^A0N,17,16^FH\^FDFABRICACAO: "+DTOC(dDtaFab)+"^FS")
MSCBWrite("^FT18,301^A0N,17,16^FH\^FDCREFITO: "+Alltrim(cCrea)+"^FS")
MSCBWrite("^FT19,275^A0N,17,16^FH\^FDENG. RESPONSAVEL: "+Alltrim(cNome)+"^FS")
MSCBWrite("^FT18,490^A0N,25,24^FH\^FDINSTRUCOES GERAIS^FS")
MSCBWrite("^FT18,516^A0N,17,16^FH\^FD- INSTRUCOES DE USO: VER MANUAL QUE ACOMPANHA O PRODUTO^FS")
MSCBWrite("^FT18,537^A0N,17,16^FH\^FD- ADVERTENCIAS/PRECAUCOES: VER MANUAL QUE ACOMPANHA O PRODUTO^FS")
//MSCBWrite("^FT415,171^A0N,20,19^FH\^FDControle de Etiqueta: "+Alltrim(STR(nNumEtq))+"/"+Alltrim(STR(nQtdEtq))+"^FS")
MSCBWrite("^FT490,507^BQN,2,9")
MSCBWrite("^FDLA,"+Alltrim(SB1->B1_COD)+"|"+Alltrim(cLotSer)+"|"+Alltrim(STRZERO(nNumEtq,3))+"^FS")
MSCBWrite("^PQ1,0,1,Y^XZ")

MSCBEND()

MSCBCLOSEPRINTER()

Return    


/*
Etiquta Colombia
*/
/*
ETIQUETA COLOMBIA
*/
Static Function fEtqCol(cCodProd, dDtaFab, cLotSer, _cInvim1)

Local cPorta   		:= GetMv("ZZ_PORTA01")
Local dDtaVenc		:= CTOD("  /  /  ")
Local nTempo		:= 0
Local cTipe			:= "NA"
Local nQtd			:= 1


dbSelectArea("SB1")
SB1->(dbSetOrder(1))
dbSeek(xFilial("SB1")+cCodProd)

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
//MSCBWrite("^FT587,80^A0I,14,14^FH\^FDINVIMA: "+Alltrim(SB1->B1_ZZINVIM)+"^FS")
MSCBWrite("^FT587,80^A0I,14,14^FH\^FDINVIMA: "+Alltrim(_cInvim1)+"^FS")
MSCBWrite("^FT587,63^A0I,14,14^FH\^FDNIT 830.109.997-9^FS")
MSCBWrite("^FT39,296^BQN,2,6")
//MSCBWrite("^FDLA,"+Alltrim(SB1->B1_COD)+"|"+Alltrim(cLotSer)+"^FS")
MSCBWrite("^FDLA,"+Alltrim(SB1->B1_COD)+"|"+Alltrim(cLotSer)+"|"+Alltrim(_cInvim1)+"^FS") // M&H Coloca el Codigo Invima 
MSCBWrite("^FT211,68^A0I,17,14^FH\^FDHecho en: "+Day2Str(dDtaFab)+"/"+Month2Str(dDtaFab)+"/"+Year2Str(dDtaFab)+"^FS")
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


/*
Etiqueta Argentina
*/
Static Function fEtqArg(cCodProd, cLotSer, cAutImp)

Local cPorta   		:= GetMv("ZZ_PORTA01")
Local cTecFuncao	:= GetMv("ZZ_TECFUNC")
Local cTecNome		:= GetMv("ZZ_TECNOME")
Local cTecDoc		:= GetMv("ZZ_TECDOC")

Local cNomFabri		:= ""
Local cEndFabri		:= ""
Local cBairFabri	:= ""
Local cCepFabri		:= ""
Local cMunFabri		:= ""
Local cEstFabri		:= ""
Local cPaisFabri	:= ""

Local cNomImpor		:= ""
Local cEndImpor		:= ""
Local cBairImpor	:= ""
Local cCepImpor		:= ""
Local cMunImpor		:= ""
Local cEstImpor		:= ""
Local cTelImpor		:= ""
Local cCnpjImpor	:= ""
Local cPaisImpor	:= ""


dbSelectArea("SB1")
SB1->(dbSetOrder(1))
dbSeek(xFilial("SB1")+cCodProd)

//FABRICANTE 
SA2->(dbSetOrder(1))
if SA2->(dbSeek(xFilial("SA2")+SB1->(B1_ZZFABRI+B1_ZZFABRL)))
	cNomFabri	:= Alltrim(SA2->A2_ZZNOME)
	cEndFabri	:= Alltrim(SA2->A2_END)
	cBairFabri	:= Alltrim(SA2->A2_BAIRRO)
	cCepFabri	:= Substr(SA2->A2_CEP,1,5) + "-" + Substr(SA2->A2_CEP,6,3)
	cMunFabri	:= Alltrim(SA2->A2_MUN)
	cEstFabri	:= Alltrim(SA2->A2_EST)
	cPaisFabri	:= Alltrim(Posicione("SYA",1,xFilial("SYA") + SA2->A2_PAIS,"YA_DESCR"))
endif	

//IMPORTADOR
SA2->(dbSetOrder(1))
if SA2->(dbSeek(xFilial("SA2")+SB1->(B1_ZZIMPOR+B1_ZZIMPOL)))
	cNomImpor	:= Alltrim(SA2->A2_ZZNOME)
	cEndImpor	:= Alltrim(SA2->A2_END)
	cBairImpor	:= Alltrim(SA2->A2_BAIRRO)
	cCepImpor	:= Substr(SA2->A2_CEP,1,5) + "-" + Substr(SA2->A2_CEP,6,3)
	cMunImpor	:= Alltrim(SA2->A2_MUN)
	cEstImpor	:= Alltrim(SA2->A2_EST)
	cTelImpor	:= "("+Alltrim(SA2->A2_DDD)+") " + Substr(SA2->A2_TEL,1,4) + "." + Substr(SA2->A2_TEL,5,4)
	cCnpjImpor	:= Transform(SA2->A2_CGC,"@r 99.999.999/9999-99")
	cPaisImpor	:= Alltrim(Posicione("SYA",1,xFilial("SYA") + SA2->A2_PAIS,"YA_DESCR"))
endif	

if SB1->B1_OBPTGAR == "M"
	cGarantia:= "MESES"
else
	cGarantia:= "ANOS"
endif			

MSCBPRINTER("S4N",cPorta,,,.f.,,,,,,.t.)
MSCBCHKSTATUS(.f.)
	
MSCBBEGIN(1,6,97)  


MSCBWrite("^XA")
MSCBWrite("^MMT")
MSCBWrite("^PW831")
MSCBWrite("^LL0713")
MSCBWrite("^LS0")
MSCBWrite("^FO19,17^GB124,28,28^FS")
MSCBWrite("^FT19,39^A0N,23,24^FR^FH\^FDFABRICANTE^FS")
MSCBWrite("^FT415,71^A0N,23,24^FH\^FD"+cNomImpor+"^FS")
MSCBWrite("^FT19,71^A0N,23,24^FH\^FD"+cNomFabri+"^FS")
MSCBWrite("^FO415,18^GB134,28,28^FS")
MSCBWrite("^FT415,40^A0N,23,24^FR^FH\^FDIMPORTADOR^FS")
MSCBWrite("^FT414,93^A0N,17,16^FH\^FD"+cEndImpor+" - "+cBairImpor+"^FS")
MSCBWrite("^FT414,114^A0N,17,16^FH\^FD"+cMunImpor+" / "+cPaisImpor+"^FS")
MSCBWrite("^FT18,93^A0N,17,16^FH\^FD"+cEndFabri+"^FS")
MSCBWrite("^FT18,114^A0N,17,16^FH\^FD"+cMunFabri+" / "+cPaisFabri+"^FS")
MSCBWrite("^FO19,132^GB162,34,34^FS")
MSCBWrite("^FT19,159^A0N,28,28^FR^FH\^FD"+cTecFuncao+"^FS")
MSCBWrite("^FO18,174^GB529,34,34^FS")
MSCBWrite("^FT18,201^A0N,28,28^FR^FH\^FDCODIGO PRODUCTO | NOMBRE DESCRIPTVO^FS")
MSCBWrite("^FO20,281^GB156,28,28^FS")
MSCBWrite("^FT20,303^A0N,23,24^FR^FH\^FDLOTE | N.SERIE^FS")
MSCBWrite("^FO19,349^GB102,28,28^FS")
MSCBWrite("^FT19,371^A0N,23,24^FR^FH\^FDGARANTIA^FS")
MSCBWrite("^FO20,386^GB267,28,28^FS")
MSCBWrite("^FT20,408^A0N,23,24^FR^FH\^FDATORIZADO POR A.N.M.A.T^FS")
MSCBWrite("^FO19,315^GB204,28,28^FS")
MSCBWrite("^FT19,337^A0N,23,24^FR^FH\^FDFECHA PRODUCCION^FS")
MSCBWrite("^FT23,542^A0N,25,24^FH\^FDVENTA EXCLUSIVA A PROFESIONALES E INSTITUICIONES SANITARIAS^FS")
MSCBWrite("^FT522,527^BQN,2,9")
MSCBWrite("^FDLA,"+Alltrim(cCodProd) +"|"+Alltrim(cLotSer)+"^FS")
MSCBWrite("^FT203,154^A0N,23,24^FH\^FD"+  cTecNome+" - "+cTecDoc+"^FS")
MSCBWrite("^FT18,268^A0N,28,28^FH\^FD"+Alltrim(SB1->B1_DESC)+"^FS")
MSCBWrite("^FT18,239^A0N,28,28^FH\^FD"+Alltrim(SB1->B1_COD)+"^FS")
MSCBWrite("^FT193,303^A0N,23,24^FH\^FD "+Alltrim(cLotSer)+"^FS")
MSCBWrite("^FT236,337^A0N,23,24^FH\^FDVer en el embalaje^FS")
MSCBWrite("^FT132,371^A0N,23,24^FH\^FD "+Alltrim(STR(SB1->B1_OBPRGAR))+" "+Alltrim(cGarantia)+"^FS")
MSCBWrite("^FT20,439^A0N,23,24^FH\^FDPMPM 1463-52^FS")
MSCBWrite("^FT21,467^A0N,17,16^FH\^FD- Ver punto de instruciones antes de utilizacion^FS")
MSCBWrite("^FT21,488^A0N,17,16^FH\^FD    En caso de utilizar pr largo tiempo, cubrir^FS")
MSCBWrite("^FT21,509^A0N,17,16^FH\^FD- Guardar retugiado del sol y llyla^FS")
MSCBWrite("^PQ1,0,1,Y^XZ")

MSCBEND()

MSCBCLOSEPRINTER()

Return

