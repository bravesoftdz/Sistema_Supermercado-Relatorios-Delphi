unit Unit_Entrada_Produtos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.Samples.Spin, Unit_Persistencia, Vcl.Grids, Vcl.Buttons;

type
  TForm_Entrada_Produtos = class(TForm)
    edtCodigoFornecedor: TLabeledEdit;
    edtFrete: TLabeledEdit;
    edtImposto: TLabeledEdit;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    lab_qtdParcelas: TLabel;
    Edit_Total: TLabeledEdit;
    edit_Entrada: TLabeledEdit;
    spin_qtdParcelas: TSpinEdit;
    edit_valorParcelas: TLabeledEdit;
    Panel4: TPanel;
    rad_formaPagamento: TRadioGroup;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel3: TPanel;
    edit_CodProduto: TLabeledEdit;
    Edit_Descricao: TLabeledEdit;
    Edit_Preco: TLabeledEdit;
    Edit_Quantidade: TLabeledEdit;
    Btn_Inserir: TBitBtn;
    Btn_Remover: TBitBtn;
    sgd_Produto: TStringGrid;
    Panel2: TPanel;
    btn_novo: TBitBtn;
    btn_limpar: TBitBtn;
    btn_cancelar: TBitBtn;
    btn_gravar: TBitBtn;
    btn_sair: TBitBtn;
    edit_CNPJ: TMaskEdit;
    cbx_Fornecedor: TComboBox;
    Label2: TLabel;
    Label3: TLabel;

    procedure rad_formaPagamentoClick(Sender: TObject);
    procedure edit_EntradaChange(Sender: TObject);
    procedure spin_qtdParcelasChange(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_limparClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_sairClick(Sender: TObject);
    procedure HabilitaBotoes(Quais: String);
    procedure HabilitaTela(Habilita: Boolean);
    procedure LimpaTela;
    procedure PintaGrid;
    Procedure TotalizaCompra;
    Function ColetaProdutos: Produtos_Venda;
    procedure PreencheComboFornecedores;
    function VerificaPreenchimento: Boolean;
    procedure alteraValorParcela();
    procedure edit_CodProdutoChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Btn_InserirClick(Sender: TObject);
    procedure edit_CodProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure Edit_QuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure Btn_RemoverClick(Sender: TObject);
    procedure edtImpostoChange(Sender: TObject);
    procedure edtFreteChange(Sender: TObject);
    procedure cbx_FornecedorSelect(Sender: TObject);
    procedure edit_EntradaKeyPress(Sender: TObject; var Key: Char);
    procedure edit_EntradaExit(Sender: TObject);
    procedure edtImpostoExit(Sender: TObject);
    procedure edtImpostoKeyPress(Sender: TObject; var Key: Char);
    procedure edtFreteExit(Sender: TObject);
    procedure edtFreteKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Entrada_Produtos: TForm_Entrada_Produtos;
  Linha: Integer;
  Novo: Boolean;
  valor_total_produtos: Real;

implementation

{$R *.dfm}

Procedure TForm_Entrada_Produtos.TotalizaCompra;
var
  I: Integer;
  Total: Real;
Begin
  Total := 0;
  For I := 1 to sgd_Produto.RowCount - 1 do
    Total := Total + StrToFloat(sgd_Produto.Cells[4, I]);
  Edit_Total.Text := FloatToStr(Total);
End;

procedure TForm_Entrada_Produtos.HabilitaBotoes(Quais: String);
begin
  if (Quais[1] = '0') then
    btn_novo.Enabled := False
  else
    btn_novo.Enabled := True;
  if (Quais[2] = '0') then
    btn_limpar.Enabled := False
  else
    btn_limpar.Enabled := True;
  if (Quais[3] = '0') then
    btn_cancelar.Enabled := False
  else
    btn_cancelar.Enabled := True;
  if (Quais[4] = '0') then
    btn_gravar.Enabled := False
  else
    btn_gravar.Enabled := True;
  if (Quais[5] = '0') then
    btn_sair.Enabled := False
  else
    btn_sair.Enabled := True;
end;

procedure TForm_Entrada_Produtos.HabilitaTela(Habilita: Boolean);
begin
  { edit_codVenda.Enabled:=   Habilita;
    edit_Data.Enabled:=       Habilita; }
  cbx_Fornecedor.Enabled := Habilita;
  edit_CodProduto.Enabled := Habilita;
  Edit_Descricao.Enabled := Habilita;
  Edit_Preco.Enabled := Habilita;
  Edit_Quantidade.Enabled := Habilita;
  // Edit_Total.Enabled:=      Habilita;
  sgd_Produto.Enabled := Habilita;
  Label1.Enabled := Habilita;
  rad_formaPagamento.Enabled := Habilita;
  Btn_Inserir.Enabled := Habilita;
  Btn_Remover.Enabled := Habilita;
  edtFrete.Enabled := Habilita;
  edtImposto.Enabled := Habilita;
end;

procedure TForm_Entrada_Produtos.LimpaTela;
begin
  edit_CodProduto.Clear;
  Edit_Descricao.Clear;
  Edit_Preco.Clear;
  Edit_Quantidade.Clear;
  cbx_Fornecedor.ItemIndex := -1;
  edtCodigoFornecedor.Clear;
  edit_CNPJ.Clear;
  edit_Entrada.Text := '0,00';
  edtImposto.Text := '0,00';
  edtFrete.Text := '0,00';
  spin_qtdParcelas.Text := '2';
  rad_formaPagamento.ItemIndex := 0;
  edit_valorParcelas.Text := '0,00';
  Edit_Total.Text := '0,00';
  sgd_Produto.RowCount := 1;
end;

procedure TForm_Entrada_Produtos.PintaGrid;
begin
  sgd_Produto.Cells[0, 0] := 'C�d.';
  sgd_Produto.Cells[1, 0] := 'Descri��o';
  sgd_Produto.Cells[2, 0] := 'Pre�o';
  sgd_Produto.Cells[3, 0] := 'Quantidade';
  sgd_Produto.Cells[4, 0] := 'Total';
  sgd_Produto.ColWidths[0] := 60;
  sgd_Produto.ColWidths[1] := 200;
  sgd_Produto.ColWidths[2] := 80;
  sgd_Produto.ColWidths[3] := 80;
  sgd_Produto.ColWidths[4] := 80;
end;

Function TForm_Entrada_Produtos.ColetaProdutos: Produtos_Venda;
Var
  I: Integer;
begin
  SetLength(Result, sgd_Produto.RowCount - 1);
  // ShowMessage('RowCount: ' + sgd_Produto.RowCount);
  for I := 1 to sgd_Produto.RowCount - 1 do
  Begin
    Result[I - 1].Codigo := StrToInt(sgd_Produto.Cells[0, I]);
    Result[I - 1].Preco := StrToFloat(sgd_Produto.Cells[2, I]);
    Result[I - 1].Quantidade := StrToInt(sgd_Produto.Cells[3, I]);
  End;
end;

procedure TForm_Entrada_Produtos.PreencheComboFornecedores;
var
  fornecedores: Fornecedores_Cadastrados;
  I: Integer;

begin
  cbx_Fornecedor.Clear;
  fornecedores := Retorna_Todos_Fornecedores_Cadastrados();

  for I := 0 to Length(fornecedores) - 1 do
  begin
    cbx_Fornecedor.Items.Add(fornecedores[I].NomeFantasia);
  end;

end;

function TForm_Entrada_Produtos.VerificaPreenchimento: Boolean;
begin
  if (cbx_Fornecedor.Items[cbx_Fornecedor.ItemIndex] = '') then
    Result := False
  else if (sgd_Produto.RowCount = 1) then
    Result := False
  else
    Result := True;
end;

procedure TForm_Entrada_Produtos.alteraValorParcela();
var
  valorParcelas: Real;
begin
  valorParcelas := (StrToFloat(Edit_Total.Text) - StrToFloat(edit_Entrada.Text))
    / spin_qtdParcelas.Value;
  edit_valorParcelas.Text := FormatFloat('0.00', valorParcelas);
end;

procedure TForm_Entrada_Produtos.edit_CodProdutoChange(Sender: TObject);
Var
  Produto_Temp: Dados_Produto;
  precoProduto: Real;
begin
  if (edit_CodProduto.Text = '') Then
    Produto_Temp.Codigo := -1
  Else
    Produto_Temp := Retorna_Dados_Produto(StrToInt(edit_CodProduto.Text));
  if (Produto_Temp.Codigo <> -1) Then
  Begin
    Edit_Descricao.Text := Produto_Temp.Descricao;
    precoProduto := StrToFloat(FormatFloat('0.00', Produto_Temp.Preco_Venda));
    Edit_Preco.Text := FloatToStr(precoProduto);
  End
  Else
  Begin
    Edit_Descricao.Text := '';
    Edit_Preco.Text := '';
  End;
end;

procedure TForm_Entrada_Produtos.edit_CodProdutoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = Chr(13)) Then
    Edit_Quantidade.SetFocus;
end;

procedure TForm_Entrada_Produtos.Edit_QuantidadeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = Chr(13)) Then
    Btn_Inserir.Click;
end;

procedure TForm_Entrada_Produtos.edtFreteChange(Sender: TObject);
begin
  TotalizaCompra;
  Edit_Total.Text := FloatToStr(StrToFloat(Edit_Total.Text) +
    StrToFloat(edtImposto.Text) + StrToFloat(edtFrete.Text));

  if (rad_formaPagamento.ItemIndex = 1) then
    alteraValorParcela();
end;

procedure TForm_Entrada_Produtos.edtFreteExit(Sender: TObject);
var str : String;
begin
str := CurrToStrF(StrToCurrDef(Trim(edtFrete.Text),0),ffNumber,2);
edtFrete.text := stringReplace(str, '.', '', []);
end;

procedure TForm_Entrada_Produtos.edtFreteKeyPress(Sender: TObject;
  var Key: Char);
begin
if not (key in ['0'..'9',#8]) then key :=#0;
end;

procedure TForm_Entrada_Produtos.edtImpostoChange(Sender: TObject);
begin
  TotalizaCompra;
  Edit_Total.Text := FloatToStr(StrToFloat(Edit_Total.Text) +
    StrToFloat(edtImposto.Text) + StrToFloat(edtFrete.Text));

  if (rad_formaPagamento.ItemIndex = 1) then
    alteraValorParcela();
end;

procedure TForm_Entrada_Produtos.edtImpostoExit(Sender: TObject);
var str : String;
begin
str := CurrToStrF(StrToCurrDef(Trim(edtImposto.Text),0),ffNumber,2);
edtImposto.text := stringReplace(str, '.', '', []);
end;

procedure TForm_Entrada_Produtos.edtImpostoKeyPress(Sender: TObject;
  var Key: Char);
begin
if not (key in ['0'..'9',#8]) then key :=#0;
end;

procedure TForm_Entrada_Produtos.FormShow(Sender: TObject);
begin
  PintaGrid;
  Linha := 1;
end;

procedure TForm_Entrada_Produtos.btn_cancelarClick(Sender: TObject);
begin
  if (Application.MessageBox('Deseja realmente cancelar?', 'Cancelar',
    MB_ICONQUESTION + MB_YESNO) = mrYes) then
  begin
    LimpaTela;
    HabilitaBotoes('10001');
    HabilitaTela(False);
  end;
end;

procedure TForm_Entrada_Produtos.btn_gravarClick(Sender: TObject);
Var
  Prods: Produtos_Venda;
  cod_Fornecedor, cod_Produto, Quantidade, total_produtos: Integer;
  imposto, valor, frete: Real;
  forma_pagamento: Boolean;
  Total, entrada, valor_parcela, valor_imposto, valor_frete: Real;
  qtdeParcelas, codigo_cliente, I: Integer;
  data_vencimento: tdatetime;
  lucro, novo_valor: Real;
begin

  if (VerificaPreenchimento()) then
  begin
    Prods := ColetaProdutos;
    cod_Fornecedor := StrToInt(edtCodigoFornecedor.Text);
    imposto := StrToFloat(edtImposto.Text);
    frete := StrToFloat(edtFrete.Text);
    if (rad_formaPagamento.ItemIndex = 0) then
    begin
      //ShowMessage('Venda a Vista');
      insere_valor_caixa('Venda a Vista', (StrToFloat(Edit_Total.Text) * -1),
        DateToStr(Date), TimeToStr(Time));
    end
    else
    begin
      //ShowMessage('Venda a Prazo');
      entrada := StrToFloat(edit_Entrada.Text);
      Total := StrToFloat(Edit_Total.Text);
      qtdeParcelas := StrToInt(spin_qtdParcelas.Text);
      data_vencimento := Date;
      data_vencimento := data_vencimento + 30;
      valor_parcela := StrToFloat(edit_valorParcelas.Text);
      for I := 1 to qtdeParcelas do
      begin
        insere_contas_pagar(DateToStr(data_vencimento), valor_parcela,
          cod_Fornecedor);
        data_vencimento := data_vencimento + 30;
      end;
      insere_valor_caixa('Entrada', (entrada * -1), DateToStr(Date),
        TimeToStr(Time));

    end;
    total_produtos := 0;

    for I := 0 to Length(Prods) - 1 do
    begin
      total_produtos := total_produtos + Prods[I].Quantidade;
    end;

    valor_imposto := imposto / total_produtos;
    valor_frete := frete / total_produtos;
    lucro := Retorna_lucro;
    for I := 0 to Length(Prods) - 1 do
    begin
      novo_valor := valor_imposto + valor_frete + Prods[I].Preco;
      novo_valor := novo_valor + (novo_valor * (lucro / 100));
      // ShowMEssage('Novo Valor: '+ FloatToStr(novo_valor));
      atualiza_produto_compra(Prods[I].Codigo, Prods[I].Quantidade, novo_valor);
    end;

    HabilitaTela(False);
    HabilitaBotoes('10001');
    LimpaTela;
  end
  else
  begin
    ShowMessage
      ('N�o foi poss�vel salvar. Preencha todos os campos obrigatorios.');
  end;
end;

procedure TForm_Entrada_Produtos.Btn_InserirClick(Sender: TObject);
Var
  Produto_Temp: Dados_Produto;
  precoProduto: Real;
begin
  if (Edit_Quantidade.Text = '') Then
  Begin
    Application.MessageBox(PChar('Informe a Quantidade de Produtos'),
      'Informe a Quantidade', MB_ICONWARNING + MB_OK);
    Edit_Quantidade.SetFocus;
    Exit;
  End;
  if (edit_CodProduto.Text = '') Then
    Produto_Temp.Codigo := -1
  Else
    Produto_Temp := Retorna_Dados_Produto(StrToInt(edit_CodProduto.Text));
  if (Produto_Temp.Codigo = -1) Then
  Begin
    Application.MessageBox
      (PChar('N�o Existe um produto cadastrado com o c�digo = ' +
      QuotedStr(edit_CodProduto.Text)), 'Produto n�o Cadastrado',
      MB_ICONERROR + MB_OK);
    Exit;
  End;
  if not((sgd_Produto.RowCount = 2) And (sgd_Produto.Cells[0, 1] = '')) Then
    sgd_Produto.RowCount := sgd_Produto.RowCount + 1;
  sgd_Produto.Cells[0, sgd_Produto.RowCount - 1] :=
    IntToStr(Produto_Temp.Codigo);
  sgd_Produto.Cells[1, sgd_Produto.RowCount - 1] := Produto_Temp.Descricao;

  precoProduto := StrToFloat(FormatFloat('0.00', StrToFloat(Edit_Preco.Text)));
  sgd_Produto.Cells[2, sgd_Produto.RowCount - 1] := FloatToStr(precoProduto);

  sgd_Produto.Cells[3, sgd_Produto.RowCount - 1] := Edit_Quantidade.Text;
  sgd_Produto.Cells[4, sgd_Produto.RowCount - 1] :=
    FloatToStr(StrToFloat(Edit_Quantidade.Text) * StrToFloat(Edit_Preco.Text));

  TotalizaCompra;
  Edit_Total.Text := FloatToStr(StrToFloat(Edit_Total.Text) +
    StrToFloat(edtImposto.Text) + StrToFloat(edtFrete.Text));

  if rad_formaPagamento.ItemIndex = 1
     then alteraValorParcela();

end;

procedure TForm_Entrada_Produtos.btn_limparClick(Sender: TObject);
begin
  If (Application.MessageBox('Deseja realmente limpar todos os campos?',
    'Limpar Campos', MB_ICONQUESTION + MB_YESNO) = mrYes) Then
    LimpaTela;
end;

procedure TForm_Entrada_Produtos.btn_novoClick(Sender: TObject);
begin
  Novo := True;
  HabilitaTela(True);
  HabilitaBotoes('01110');
  PintaGrid;
  PreencheComboFornecedores;
  cbx_Fornecedor.SetFocus;
end;

procedure TForm_Entrada_Produtos.Btn_RemoverClick(Sender: TObject);
var
  I: Integer;
begin
  if sgd_Produto.RowCount = 2 then
  Begin
    sgd_Produto.Cells[0, 1] := '';
    sgd_Produto.Cells[1, 1] := '';
    sgd_Produto.Cells[2, 1] := '';
    sgd_Produto.Cells[3, 1] := '';
    sgd_Produto.Cells[4, 1] := '';
    sgd_Produto.RowCount := 1;
    TotalizaCompra;
    Exit;
  End;

  for I := Linha to sgd_Produto.RowCount do
  Begin
    sgd_Produto.Cells[0, I] := sgd_Produto.Cells[0, I + 1];
    sgd_Produto.Cells[1, I] := sgd_Produto.Cells[1, I + 1];
    sgd_Produto.Cells[2, I] := sgd_Produto.Cells[2, I + 1];
    sgd_Produto.Cells[3, I] := sgd_Produto.Cells[3, I + 1];
    sgd_Produto.Cells[4, I] := sgd_Produto.Cells[4, I + 1];
  End;
  sgd_Produto.RowCount := sgd_Produto.RowCount - 1;
  TotalizaCompra;
  PintaGrid;
end;

procedure TForm_Entrada_Produtos.btn_sairClick(Sender: TObject);
begin
  Form_Entrada_Produtos.Close;
end;

procedure TForm_Entrada_Produtos.cbx_FornecedorSelect(Sender: TObject);
var
  forn: Dados_Fornecedor;
begin
  forn := Retorna_Fornecedor(cbx_Fornecedor.Items[cbx_Fornecedor.ItemIndex]);
  edit_CNPJ.Text := forn.CNPJ;
  edtCodigoFornecedor.Text := IntToStr(forn.Codigo);
end;

procedure TForm_Entrada_Produtos.edit_EntradaChange(Sender: TObject);
var
  valorParcelas: Real;
begin
  valorParcelas := (StrToFloat(Edit_Total.Text) - StrToFloat(edit_Entrada.Text))
    / spin_qtdParcelas.Value;
  edit_valorParcelas.Text := FloatToStr(valorParcelas);
end;

procedure TForm_Entrada_Produtos.edit_EntradaExit(Sender: TObject);
var str : String;
begin
str := CurrToStrF(StrToCurrDef(Trim(edit_Entrada.Text),0),ffNumber,2);
edit_Entrada.text := stringReplace(str, '.', '', []);
end;

procedure TForm_Entrada_Produtos.edit_EntradaKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8]) then key :=#0;
end;

procedure TForm_Entrada_Produtos.rad_formaPagamentoClick(Sender: TObject);
var
  valorParcelas: Real;

begin
  if rad_formaPagamento.ItemIndex = 1 then
  begin
    edit_Entrada.Enabled := True;
    lab_qtdParcelas.Enabled := True;
    spin_qtdParcelas.Enabled := True;

    valorParcelas := (StrToFloat(Edit_Total.Text) -
      StrToFloat(edit_Entrada.Text)) / spin_qtdParcelas.Value;
    edit_valorParcelas.Text := FloatToStr(valorParcelas);
  end
  else
  begin
    edit_Entrada.Enabled := False;
    lab_qtdParcelas.Enabled := False;
    spin_qtdParcelas.Enabled := False;
  end;
end;

procedure TForm_Entrada_Produtos.spin_qtdParcelasChange(Sender: TObject);
var
  valorParcelas: Real;
begin
  valorParcelas := (StrToFloat(Edit_Total.Text) - StrToFloat(edit_Entrada.Text))
    / spin_qtdParcelas.Value;
  valorParcelas := StrToFloat(FormatFloat('0.00', valorParcelas));
  edit_valorParcelas.Text := FloatToStr(valorParcelas);
end;

end.
