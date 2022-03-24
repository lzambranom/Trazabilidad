#Include 'TOTVS.ch'
#Include 'FWMVCDef.ch'
/*/{Protheus.doc} MAESZZA
description
@type function
@version 
@author Axel Diaz
@since 28/3/2020
@return return_type, return_description
/*/
USER FUNCTION MAESZZA()
    Local oBrowse
    Local aArea			:= GetArea()
    Local cZZA			:= GetNextAlias()
    Private aRotina		:= MenuDef()
    Private lRet	    := .T.
    Private nOpcAuto    := 0
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZA")
    oBrowse:SetDescription('Maestro Pacientes')
    oBrowse:SetLocate()
    oBrowse:Refresh(.T.)
    oBrowse:Activate()
    oBrowse:Destroy()
    RestArea(aArea)
RETURN

/*/{Protheus.doc} MenuDef()
    @type  Static Function
    @author user
    @since 28/03/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

Static Function MenuDef()
    Local aRotina := {}
    ADD OPTION aRotina TITLE 'Visualizar'       ACTION 'VIEWDEF.MAESZZA'        OPERATION MODEL_OPERATION_VIEW   ACCESS 0 // 2
    ADD OPTION aRotina TITLE 'Incluir'          ACTION 'VIEWDEF.MAESZZA'        OPERATION MODEL_OPERATION_INSERT ACCESS 0 // 3
    ADD OPTION aRotina TITLE 'Modificar'        ACTION 'VIEWDEF.MAESZZA'        OPERATION MODEL_OPERATION_UPDATE ACCESS 0 // 4
    ADD OPTION aRotina TITLE 'Borrar'           ACTION 'U_MAEZZADelet(oModel)'  OPERATION MODEL_OPERATION_DELETE ACCESS 0 // 5
    ADD OPTION aRotina TITLE 'Imprimir'         ACTION 'VIEWDEF.MAESZZA'        OPERATION 8 ACCESS 0
Return aRotina

/*/{Protheus.doc} ModelDef()
    @type  Static Function
    @author user
    @since 28/03/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function ModelDef()
    Local oStruZZA := FWFormStruct( 1, 'ZZA' )
    Local oModel
    oModel:=MPFormModel():New('MAESZZAM', /*bPre*/,/*bPost*/{ | oModel | PosCommit(oModel)},/*bCommit*/,/*bCancel*/)
    oModel:AddFields( 'ZZAMASTER', /*cOwner*/, oStruZZA)
    oModel:SetDescription( 'Pacientes' )
    oModel:GetModel( 'ZZAMASTER' )
    oModel:SetDescription( 'Datos del Paciente' )
    oModel:SetPrimaryKey( {} )
Return oModel


/*/{Protheus.doc} ViewDef()
    @type  Static Function
    @author user
    @since 28/03/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function ViewDef()
    Local oModel    := FWLoadModel( 'MAESZZA' )
    Local oStruZZA  := FWFormStruct( 2, 'ZZA' )
    Local oView
    oView := FWFormView():New()
    oView:SetModel( oModel )
    oView:AddField( 'VIEW_ZZA', oStruZZA, 'ZZAMASTER' )
    oView:CreateHorizontalBox( 'Paciente' , 100 )
    oView:SetOwnerView( 'VIEW_ZZA', 'Paciente' )
Return oView


/*/{Protheus.doc} MAEZZADelet
Elimina el Resgistro Paciente
@type function
@version 
@author Axel Diaz
@since 28/3/2020
@return return_type, return_description  //1042066617     '
/*/
User Function MAEZZADelet()
    Local oModel	:= FWLoadModel('MAESZZA')
    Local oModelZZA	
    Local cZACOD    := ""
    Local cZALOJA   := ""

    Local cKeySE1	:= ""
    Local cKeySE2	:= ""
    Local cKeySF2   := ""
    Local cKeySF1   := ""
    Local cKeySC5   := ""
    Local cKeySCJ   := ""
    Local cKeySC9   := ""
    Local cKeySEL   := ""
    Local cKeySF3   := ""

    Local lKeySE1	:= .T.
    Local lKeySE2	:= .T.
    Local lKeySF2   := .T.
    Local lKeySF1   := .T.
    Local lKeySC5   := .T.
    Local lKeySCJ   := .T.
    Local lKeySC9   := .T.
    Local lKeySEL   := .T.
    Local lKeySF3   := .T.

    lRet	:= .T.

    If oModel:Activate(.T.)
        oModelZZA:= oModel:GetModel('ZZAMASTER')
        cZACOD   := oModelZZA:GetValue("ZZA_COD" )
        cZALOJA  := oModelZZA:GetValue("ZZA_LOJA")

        cZALOJA  := IIF(EMPTY(ALLTRIM(cZALOJA)),"01",cZALOJA)
        // Busncado en tabla Clientes
        cKeySE1	 := xFilial("SE1") + cZACOD + cZALOJA
        cKeySE2	 := xFilial("SE2") + cZACOD + cZALOJA
        cKeySF1  := xFilial("SF1") + cZACOD + cZALOJA // SF1 F1_CLIORI, F1_FORNECE
        cKeySF2  := xFilial("SF2") + cZACOD + cZALOJA // SF2 F2_CLIENT, F2_CLIENTE
        cKeySC5  := xFilial("SC5") + cZACOD + cZALOJA // SC5 C5_CLIENTE, C5_CLIENT
        cKeySCJ  := xFilial("SCJ") + cZACOD + cZALOJA // SCJ CJ_CLIENT
        cKeySC9  := xFilial("SC9") + cZACOD + cZALOJA // SC9 CO_CLIENTE
        cKeySEL  := xFilial("SEL") + cZACOD + cZALOJA // SEL EL_CLIENTE
        cKeySF3  := xFilial("SF3") + cZACOD + cZALOJA // SF3 F3_CLIFOR  SF3 F3_CLIENT

        lKeySE1  := IIF(EMPTY(ALLTRIM(POSICIONE('SE1',2,cKeySE1,'E1_CLIENTE'))),.T.,.F.)
        lKeySE2  := IIF(EMPTY(ALLTRIM(POSICIONE('SE2',2,cKeySE2,'E2_FORNECE'))),.T.,.F.)
        lKeySF2  := IIF(EMPTY(ALLTRIM(POSICIONE('SF2',2,cKeySF2,'F2_CLIENTE'))),.T.,.F.)
        lKeySF1  := IIF(EMPTY(ALLTRIM(POSICIONE('SF1',2,cKeySF1,'F1_FORNECE'))),.T.,.F.)
        lKeySC5  := IIF(EMPTY(ALLTRIM(POSICIONE('SC5',5,cKeySC5,'C5_CLIENTE'))),.T.,.F.)
        lKeySCJ  := IIF(EMPTY(ALLTRIM(POSICIONE('SCJ',3,cKeySCJ,'CJ_CLIENTE'))),.T.,.F.)
        lKeySC9  := IIF(EMPTY(ALLTRIM(POSICIONE('SC9',2,cKeySC9,'C9_CLIENTE'))),.T.,.F.)
        lKeySEL  := IIF(EMPTY(ALLTRIM(POSICIONE('SEL',3,cKeySEL,'EL_CLIORIG'))),.T.,.F.)
        lKeySF3  := IIF(EMPTY(ALLTRIM(POSICIONE('SF3',4,cKeySF3,'F3_CLIEFOR'))),.T.,.F.) 

        IF  (lKeySE1 .AND. lKeySE2 .AND. lKeySF2 .AND. lKeySF1 .AND. lKeySC5 .AND. ;
                lKeySCJ .AND. lKeySC9 .AND. lKeySEL .AND. lKeySF3)
            FWExecView("Eliminar Registro",'VIEWDEF.MAESZZA',MODEL_OPERATION_DELETE,,{|| .T.})
        else
            HELP(NIL, NIL,"HELP"            ,   ,"No se pudo borrar Cliente"                      , 2, 0, NIL, NIL, NIL, NIL, NIL,{"Este Cliente/Paciente ya tiene movimientos en el Sistema"})
        EndIf
    Else
        Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0)
    EndIf
Return lRet

/*/{Protheus.doc} PosCommit
description
@type function
@version 
@author Axel Diaz
@since 28/3/2020
@param oModel, object, param_description
@return return_type, return_description
/*/
Static Function PosCommit(oModel)
    Local oModelZZA	:= oModel:GetModel('ZZAMASTER')
    Local cChaveSA1 := ""
    Private cZABAIRR  := ""
    Private cZACEP    := ""
    Private cZACOD    := ""
    Private cZAEMAIL  := ""
    Private cZAEND    := ""
    Private cZAEST    := ""
    Private cZACOD_MU := ""
    Private cZAMSBLQ  := ""
    Private cZAMUN    := ""
    Private cZANOME   := ""
    Private cZANRED   := ""
    Private cZAPRAPE  := ""
    Private cZAPRNOM  := ""
    Private cZASEGAPE := ""
    Private cZASEGNOM := ""
    Private cZATEL    := ""
    Private cZATIPDOC := ""
    Private dZAFECNAC := ""
    Private cZALOJA   := ""
    Private cA1ZZEPS  := "PAC"
    Private cA1RETICA := "N"
    Private cA1NATUREZ:= "000001    "
    Private cA1CONTA  := "13050500            "
    Private cA1RETIVA := "N"
    Private cA1RETFUEN:= "N"
    Private cA1XCTAANT:= "28050501            "
    Private cA1COND   := "002"
    Private cA1ZZCLASS:= "3"
    Private cA1PESSOA := "F"
    Private lMsErroAuto := .F.

    lRet        := .T.
    nOpcAuto	:= oModel:GetOperation()

    If nOpcAuto==MODEL_OPERATION_INSERT .OR. nOpcAuto==MODEL_OPERATION_UPDATE .or. nOpcAuto==MODEL_OPERATION_DELETE
        cZACOD	    := oModelZZA:GetValue("ZZA_COD" )
        cZALOJA     := oModelZZA:GetValue("ZZA_LOJA")
        cZALOJA     := IIF(EMPTY(ALLTRIM(cZALOJA)),"01",cZALOJA)
        cZABAIRR    := oModelZZA:GetValue("ZZA_BAIRR")
        cZACEP      := oModelZZA:GetValue("ZZA_CEP")
        cZACOD      := oModelZZA:GetValue("ZZA_COD")
        cZAEMAIL    := oModelZZA:GetValue("ZZA_EMAIL")
        cZAEND      := oModelZZA:GetValue("ZZA_END")
        cZAEST      := oModelZZA:GetValue("ZZA_EST")
        cZACOD_MU   := oModelZZA:GetValue("ZZA_COD_MU")
        cZAMSBLQ    := oModelZZA:GetValue("ZZA_MSBLQ")
        cZAMUN      := oModelZZA:GetValue("ZZA_MUN")
        cZANOME     := ALLTRIM(oModelZZA:GetValue("ZZA_NOME"))
        cZANRED     := oModelZZA:GetValue("ZZA_NRED")
        cZAPRAPE    := ALLTRIM(oModelZZA:GetValue("ZZA_PRAPE"))
        cZAPRNOM    := ALLTRIM(oModelZZA:GetValue("ZZA_PRNOM"))
        cZASEGAPE   := ALLTRIM(oModelZZA:GetValue("ZZA_SEGAPE"))
        cZASEGNOM   := ALLTRIM(oModelZZA:GetValue("ZZA_SEGNOM"))
        cZATEL      := oModelZZA:GetValue("ZZA_TEL")
        cZATIPDOC   := oModelZZA:GetValue("ZZA_TIPDOC")
        dZAFECNAC   := oModelZZA:GetValue("ZZA_FECNAC")
        cZANOME     :=IIF(EMPTY(cZANOME),cZAPRNOM+" "+cZASEGNOM+" "+cZAPRAPE+" "+cZASEGAPE,cZANOME)       
    EndIf

    If nOpcAuto==MODEL_OPERATION_INSERT
        DbSelectArea("SA1")
        cChaveSA1:= xFilial("SA1") +cZACOD+cZALOJA
        DbSetOrder(1)
        IF DbSeek(cChaveSA1)
            DBCLOSEAREA("SA1")
            HELP(' ',1,"Cliente ya existe en SA1" ,,"Solo se agregará este registro en la tabla de Paciente",2,0,,,,,, {"Revise Registro en ambas tablas"})
        Else
            DBCLOSEAREA("SA1")
            Processa( {|| ZZAEXC(nOpcAuto,@lRet) }, "Procesando...", "Incluyendo registro en la tabla de Clientes",.F.)
        EndIf
    ElseIf nOpcAuto==MODEL_OPERATION_UPDATE
        DbSelectArea("SA1")
        cChaveSA1:= xFilial("SA1") +cZACOD+cZALOJA
        DbSetOrder(1)
        IF !DbSeek(cChaveSA1)
            DBCLOSEAREA("SA1")
            Processa( {|| ZZAEXC(nOpcAuto,@lRet) }, "Procesando...", "Incluyendo registro en la tabla de Clientes",.F.)
            If !lRet
                HELP(' ',1,"Cliente No existe" ,,"Se intentó crear este registro en la Tabla de Cliente",2,0,,,,,, {"Repita la operación y anote el Mensaje Anterior"})
                lRet:=.T.
            EndIf
        else
            DBCLOSEAREA("SA1")
            Processa( {|| ZZAEXC(nOpcAuto,@lRet) }, "Procesando...", "Modificando registro en la tabla de Clientes",.F.)
            If !lRet
                HELP(' ',1,"Cliente/Paciente no modificado" ,,"Se intentó modificar el Registro Paciente en la Tabla de Cliente",2,0,,,,,, {"Repita la operación y anote el Mensaje Anterior"})
            EndIf
        EndIf
    ElseIf nOpcAuto==MODEL_OPERATION_DELETE
            DbSelectArea("SA1")
            cChaveSA1:= xFilial("SA1") +cZACOD+cZALOJA
            DbSetOrder(1)
            IF DbSeek(cChaveSA1)
                DBCLOSEAREA("SA1")
                Processa( {|| ZZAEXC(nOpcAuto,@lRet) }, "Procesando...", "Eliminando registro en la tabla de Clientes",.F.)
            ELSE
                DBCLOSEAREA("SA1")    
            EndIf
            
            IF !lRet
                lRet:=.T.
                HELP(' ',1,"HELP" ,,"No se pudo borrar Cliente",2,0,,,,,, {"Registro de Paciente será eliminado, no obstante revise tabla de Cliente"})
            EndIf
    EndIf
Return lRet

/*/{Protheus.doc} ZZAEXC
description
@type function
@version 
@author Axel Diaz
@since 29/3/2020
@param nOpcAuto, numeric, param_description
@param lRet, logical, param_description
@return return_type, return_description
/*/
Static Function ZZAEXC(nOpcAuto,lRet)
    Local aSA1Auto  := {}
    Local aAI0Auto	:= {}
    Private lMsErroAuto := .F.
 /*
    aAdd(aSA1Auto,{"A1_COD"     ,ALLTRIM(SUBSTR(cZACOD      +SPACE(TAMSX3("A1_COD")[1])     ,1,TAMSX3("A1_COD")[1]))     ,Nil})
    aAdd(aSA1Auto,{"A1_LOJA"    ,ALLTRIM(SUBSTR(cZALOJA     +SPACE(TAMSX3("A1_LOJA")[1])    ,1,TAMSX3("A1_LOJA")[1]))    ,Nil})
    aAdd(aSA1Auto,{"A1_NOME"    ,ALLTRIM(SUBSTR(cZANOME     +SPACE(TAMSX3("A1_NOME")[1])    ,1,TAMSX3("A1_NOME")[1]))    ,Nil})
    aAdd(aSA1Auto,{"A1_PESSOA"  ,ALLTRIM(SUBSTR(cA1PESSOA   +SPACE(TAMSX3("A1_PESSOA")[1])  ,1,TAMSX3("A1_PESSOA")[1]))  ,Nil})
    aAdd(aSA1Auto,{"A1_BAIRRO"  ,ALLTRIM(SUBSTR(cZABAIRR    +SPACE(TAMSX3("A1_BAIRRO")[1])  ,1,TAMSX3("A1_BAIRRO")[1]))  ,Nil})
    aAdd(aSA1Auto,{"A1_CEP"     ,ALLTRIM(SUBSTR(cZACEP      +SPACE(TAMSX3("A1_CEP")[1])     ,1,TAMSX3("A1_CEP")[1]))     ,Nil})
    aAdd(aSA1Auto,{"A1_PFISICA" ,ALLTRIM(SUBSTR(cZACOD      +SPACE(TAMSX3("A1_PFISICA")[1]) ,1,TAMSX3("A1_PFISICA")[1])) ,Nil})
    aAdd(aSA1Auto,{"A1_EMAIL"   ,ALLTRIM(SUBSTR(cZAEMAIL    +SPACE(TAMSX3("A1_EMAIL")[1])   ,1,TAMSX3("A1_EMAIL")[1]))   ,Nil})
    aAdd(aSA1Auto,{"A1_END"     ,ALLTRIM(SUBSTR(cZAEND      +SPACE(TAMSX3("A1_END")[1])     ,1,TAMSX3("A1_END")[1]))     ,Nil})
    aAdd(aSA1Auto,{"A1_EST"     ,ALLTRIM(SUBSTR(cZAEST      +SPACE(TAMSX3("A1_EST")[1])     ,1,TAMSX3("A1_EST")[1]))     ,Nil})
    aAdd(aSA1Auto,{"A1_COD_MUN" ,ALLTRIM(SUBSTR(cZACOD_MU   +SPACE(TAMSX3("A1_COD_MUN")[1]) ,1,TAMSX3("A1_COD_MUN")[1])) ,Nil})
    aAdd(aSA1Auto,{"A1_MSBLQL"  ,ALLTRIM(SUBSTR(cZAMSBLQ    +SPACE(TAMSX3("A1_MSBLQL")[1])  ,1,TAMSX3("A1_MSBLQL")[1]))  ,Nil})
    aAdd(aSA1Auto,{"A1_MUN"     ,ALLTRIM(SUBSTR(cZAMUN      +SPACE(TAMSX3("A1_MUN")[1])     ,1,TAMSX3("A1_MUN")[1]))     ,Nil}) 
    aAdd(aSA1Auto,{"A1_NREDUZ"  ,ALLTRIM(SUBSTR(cZANRED     +SPACE(TAMSX3("A1_NREDUZ")[1])  ,1,TAMSX3("A1_NREDUZ")[1]))  ,Nil})
    aAdd(aSA1Auto,{"A1_NOMEMAT" ,ALLTRIM(SUBSTR(cZAPRAPE    +SPACE(TAMSX3("A1_NOMEMAT")[1]) ,1,TAMSX3("A1_NOMEMAT")[1])) ,Nil})
    aAdd(aSA1Auto,{"A1_NOMEPRI" ,ALLTRIM(SUBSTR(cZAPRNOM    +SPACE(TAMSX3("A1_NOMEPRI")[1]) ,1,TAMSX3("A1_NOMEPRI")[1])) ,Nil})
    aAdd(aSA1Auto,{"A1_NOMEPAT" ,ALLTRIM(SUBSTR(cZASEGAPE   +SPACE(TAMSX3("A1_NOMEPAT")[1]) ,1,TAMSX3("A1_NOMEPAT")[1])) ,Nil})
    aAdd(aSA1Auto,{"A1_NOMEPES" ,ALLTRIM(SUBSTR(cZASEGNOM   +SPACE(TAMSX3("A1_NOMEPES")[1]) ,1,TAMSX3("A1_NOMEPES")[1])) ,Nil})
    aAdd(aSA1Auto,{"A1_TEL"     ,ALLTRIM(SUBSTR(cZATEL      +SPACE(TAMSX3("A1_TEL")[1])     ,1,TAMSX3("A1_TEL")[1]))     ,Nil})
    aAdd(aSA1Auto,{"A1_TIPDOC"  ,ALLTRIM(SUBSTR(cZATIPDOC   +SPACE(TAMSX3("A1_TIPDOC")[1])  ,1,TAMSX3("A1_TIPDOC")[1]))  ,Nil})
    aAdd(aSA1Auto,{"A1_ZZPACIE" ,ALLTRIM(SUBSTR(cZACOD      +SPACE(TAMSX3("A1_ZZPACIE")[1]) ,1,TAMSX3("A1_ZZPACIE")[1])) ,Nil})
    aAdd(aSA1Auto,{"A1_ZZEPS"   ,ALLTRIM(SUBSTR(cA1ZZEPS    +SPACE(TAMSX3("A1_ZZEPS")[1])   ,1,TAMSX3("A1_ZZEPS")[1]))   ,Nil})
    aAdd(aSA1Auto,{"A1_DTNASC"  ,dZAFECNAC                                                                               ,Nil})
    aAdd(aSA1Auto,{"A1_RETICA"  ,ALLTRIM(SUBSTR(cA1RETICA   +SPACE(TAMSX3("A1_RETICA")[1])  ,1,TAMSX3("A1_RETICA")[1]))  ,Nil})
    aAdd(aSA1Auto,{"A1_NATUREZ" ,ALLTRIM(SUBSTR(cA1NATUREZ  +SPACE(TAMSX3("A1_NATUREZ")[1]) ,1,TAMSX3("A1_NATUREZ")[1])) ,Nil})
    aAdd(aSA1Auto,{"A1_CONTA"   ,ALLTRIM(SUBSTR(cA1CONTA    +SPACE(TAMSX3("A1_CONTA")[1])   ,1,TAMSX3("A1_CONTA")[1]))   ,Nil})
    aAdd(aSA1Auto,{"A1_RETIVA"  ,ALLTRIM(SUBSTR(cA1RETIVA   +SPACE(TAMSX3("A1_RETIVA")[1])  ,1,TAMSX3("A1_RETIVA")[1]))  ,Nil})
    aAdd(aSA1Auto,{"A1_RETFUEN" ,ALLTRIM(SUBSTR(cA1RETFUEN  +SPACE(TAMSX3("A1_RETFUEN")[1]) ,1,TAMSX3("A1_RETFUEN")[1])) ,Nil})
    aAdd(aSA1Auto,{"A1_XCTAANT" ,ALLTRIM(SUBSTR(cA1XCTAANT  +SPACE(TAMSX3("A1_XCTAANT")[1]) ,1,TAMSX3("A1_XCTAANT")[1])) ,Nil})
    aAdd(aSA1Auto,{"A1_COND"    ,ALLTRIM(SUBSTR(cA1COND     +SPACE(TAMSX3("A1_COND")[1])    ,1,TAMSX3("A1_COND")[1]))    ,Nil})
    aAdd(aSA1Auto,{"A1_ZZCLASS" ,ALLTRIM(SUBSTR(cA1ZZCLASS  +SPACE(TAMSX3("A1_ZZCLASS")[1]) ,1,TAMSX3("A1_ZZCLASS")[1])) ,Nil})
*/

//    aAdd(aSA1Auto,{"A1_FILIAL ",XFILIAL("SA1")                                         ,Nil})
    aAdd(aSA1Auto,{"A1_COD"     ,SUBSTR(ALLTRIM(cZACOD)+SPACE(TAMSX3("A1_COD")[1]),1,TAMSX3("A1_COD")[1])     ,Nil})
    aAdd(aSA1Auto,{"A1_LOJA"    ,SUBSTR(ALLTRIM(cZALOJA)+SPACE(TAMSX3("A1_LOJA")[1]),1,TAMSX3("A1_LOJA")[1])    ,Nil})


    IF nOpcAuto<>MODEL_OPERATION_DELETE
        aAdd(aSA1Auto,{"A1_NOME   ",SUBSTR(ALLTRIM(cZANOME)    ,1,TAMSX3("A1_NOME")[1])    ,Nil})
        aAdd(aSA1Auto,{"A1_PESSOA ",SUBSTR(ALLTRIM(cA1PESSOA)  ,1,TAMSX3("A1_PESSOA")[1])  ,Nil})
        aAdd(aSA1Auto,{"A1_BAIRRO ",SUBSTR(ALLTRIM(cZABAIRR)   ,1,TAMSX3("A1_BAIRRO")[1])  ,Nil})
        aAdd(aSA1Auto,{"A1_CEP    ",SUBSTR(ALLTRIM(cZACEP)     ,1,TAMSX3("A1_CEP")[1])     ,Nil})
        aAdd(aSA1Auto,{"A1_PFISICA",SUBSTR(ALLTRIM(cZACOD)     ,1,TAMSX3("A1_PFISICA")[1]) ,Nil})
        aAdd(aSA1Auto,{"A1_EMAIL  ",SUBSTR(ALLTRIM(cZAEMAIL)   ,1,TAMSX3("A1_EMAIL")[1])   ,Nil})
        aAdd(aSA1Auto,{"A1_END    ",SUBSTR(ALLTRIM(cZAEND)     ,1,TAMSX3("A1_END")[1])     ,Nil})
        aAdd(aSA1Auto,{"A1_EST    ",SUBSTR(ALLTRIM(cZAEST)     ,1,TAMSX3("A1_EST")[1])     ,Nil})
        aAdd(aSA1Auto,{"A1_COD_MUN",SUBSTR(ALLTRIM(cZACOD_MU)  ,1,TAMSX3("A1_COD_MUN")[1]) ,Nil})
        aAdd(aSA1Auto,{"A1_MSBLQL ",SUBSTR(ALLTRIM(cZAMSBLQ)   ,1,TAMSX3("A1_MSBLQL")[1])  ,Nil})
        aAdd(aSA1Auto,{"A1_MUN    ",SUBSTR(ALLTRIM(cZAMUN)     ,1,TAMSX3("A1_MUN")[1])     ,Nil}) 
        aAdd(aSA1Auto,{"A1_NREDUZ ",SUBSTR(ALLTRIM(cZANRED)    ,1,TAMSX3("A1_NREDUZ")[1])  ,Nil})
        aAdd(aSA1Auto,{"A1_NOMEMAT",SUBSTR(ALLTRIM(cZAPRAPE)   ,1,TAMSX3("A1_NOMEMAT")[1]) ,Nil})
        aAdd(aSA1Auto,{"A1_NOMEPRI",SUBSTR(ALLTRIM(cZAPRNOM)   ,1,TAMSX3("A1_NOMEPRI")[1]) ,Nil})
        aAdd(aSA1Auto,{"A1_NOMEPAT",SUBSTR(ALLTRIM(cZASEGAPE)  ,1,TAMSX3("A1_NOMEPAT")[1]) ,Nil})
        aAdd(aSA1Auto,{"A1_NOMEPES",SUBSTR(ALLTRIM(cZASEGNOM)  ,1,TAMSX3("A1_NOMEPES")[1]) ,Nil})
        aAdd(aSA1Auto,{"A1_TEL    ",SUBSTR(ALLTRIM(cZATEL)     ,1,TAMSX3("A1_TEL")[1])     ,Nil})
        aAdd(aSA1Auto,{"A1_TIPDOC ",SUBSTR(ALLTRIM(cZATIPDOC)  ,1,TAMSX3("A1_TIPDOC")[1])  ,Nil})
        aAdd(aSA1Auto,{"A1_ZZPACIE",SUBSTR(ALLTRIM(cZACOD)     ,1,TAMSX3("A1_ZZPACIE")[1]) ,Nil})
        aAdd(aSA1Auto,{"A1_ZZEPS  ",SUBSTR(ALLTRIM(cA1ZZEPS)   ,1,TAMSX3("A1_ZZEPS")[1])   ,Nil})
        aAdd(aSA1Auto,{"A1_DTNASC ",dZAFECNAC                                              ,Nil})
        aAdd(aSA1Auto,{"A1_RETICA ",SUBSTR(ALLTRIM(cA1RETICA)  ,1,TAMSX3("A1_RETICA")[1])  ,Nil})
        aAdd(aSA1Auto,{"A1_NATUREZ",SUBSTR(ALLTRIM(cA1NATUREZ) ,1,TAMSX3("A1_NATUREZ")[1]) ,Nil})
        aAdd(aSA1Auto,{"A1_CONTA  ",SUBSTR(ALLTRIM(cA1CONTA)   ,1,TAMSX3("A1_CONTA")[1])   ,Nil})
        aAdd(aSA1Auto,{"A1_RETIVA ",SUBSTR(ALLTRIM(cA1RETIVA)  ,1,TAMSX3("A1_RETIVA")[1])  ,Nil})
        aAdd(aSA1Auto,{"A1_RETFUEN",SUBSTR(ALLTRIM(cA1RETFUEN) ,1,TAMSX3("A1_RETFUEN")[1]) ,Nil})
        aAdd(aSA1Auto,{"A1_XCTAANT",SUBSTR(ALLTRIM(cA1XCTAANT) ,1,TAMSX3("A1_XCTAANT")[1]) ,Nil})
        aAdd(aSA1Auto,{"A1_COND   ",SUBSTR(ALLTRIM(cA1COND)    ,1,TAMSX3("A1_COND")[1])    ,Nil})
        aAdd(aSA1Auto,{"A1_ZZCLASS",SUBSTR(ALLTRIM(cA1ZZCLASS) ,1,TAMSX3("A1_ZZCLASS")[1]) ,Nil})
    EndIF

    //MSExecAuto({|x,y| Mata030(x,y)},aSA1Auto,nOpcAuto)
    MSExecAuto({|a,b,c| CRMA980(a,b,c)}, aSA1Auto, nOpcAuto, aAI0Auto)

    If lMsErroAuto
        lRet:=.F.
        MostraErro()
    EndIf
Return lRet