#Include "Protheus.Ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M261BCHOI �Autor  �Caio Pereira        � Data �  03/29/12   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
Ponto de entrada criado para criar novas linhas do item selecionado para
mudanca de numeracao de lote.
���������������������������������������������������������������������������*/
User Function M261BCHOI()

	Local aButtons 	:= {}
	Local aArea		:= GetArea()

		
    IF isincallstack("MATA261") .AND. INCLUI
		Aadd(aButtons ,{"DOCUMENTO.PNG"	,	{|| u_ARGEN002(1) }	, "Importo mediante el Documento" , "Documentos" })
		Aadd(aButtons ,{"DEPOSITO.PNG"	,	{|| u_ARGEN002(2) }	, "Importo mediante el Deposito y la Ubicacion" , "Depositos" })
		Aadd(aButtons ,{"ARCHIVO.PNG"	,	{|| u_ARGEN002(3) }	, "Importo mediante un Archivo CSV" , "Archivo" })
	Endif

    RestArea(aArea)	

Return(aButtons)
