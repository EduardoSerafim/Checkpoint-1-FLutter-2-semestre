import 'package:financas_pessoais/models/tipo_cartao.dart';
import 'package:financas_pessoais/repository/cartao_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';

import '../models/cartao.dart';

class CartaoCadastroPage extends StatefulWidget {
  Cartao? cartaoParaEdicao;
  CartaoCadastroPage({Key? key, this.cartaoParaEdicao}) : super(key: key);

  @override
  State<CartaoCadastroPage> createState() => __CartaoCadastroPageState();
}

class __CartaoCadastroPageState extends State<CartaoCadastroPage> {
  final _cartaoRepository = CartaoRepository();

  final _numeroController = TextEditingController();
  final _dataVencimentoController = TextEditingController();
  final _agenciaController = TextEditingController();
  final _codigoSegurancaController = TextEditingController();
  final _bancoController = TextEditingController();

  TipoCartao tipoCartaoSelecionado = TipoCartao.CREDITO;

  @override
  void initState() {
    super.initState();

    final cartao = widget.cartaoParaEdicao;
    if (cartao != null) {
      _codigoSegurancaController.text = cartao.codigoSeguranca.toString();
      _numeroController.text = cartao.numero.toString();
      tipoCartaoSelecionado = cartao.tipoCartao;
      _agenciaController.text = cartao.agencia.toString();
      _dataVencimentoController.text =
          DateFormat('MM/dd/yyyy').format(cartao.dateVencimento);
    }
  }

  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Cartão'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildNumero(),
                const SizedBox(height: 20),
                _buildCreditoDebito(),
                const SizedBox(height: 20),
                // _buildBanco(),
                // const SizedBox(height: 20),
                _buildAgencia(),
                const SizedBox(height: 20),
                _buildCodigoSeguranca(),
                const SizedBox(height: 20),
                _buildDataVencimento(),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                _buildButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Cadastrar'),
        ),
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            final numero = int.parse(_numeroController.text);
            final agencia = int.parse(_agenciaController.text);
            final codigoSeguranca = int.parse(_codigoSegurancaController.text);
            final banco = _bancoController.text;
            final dataVencimento =
                DateFormat('dd/MM/yyyy').parse(_dataVencimentoController.text);
            final cartao = Cartao(
                //banco: banco,
                //contaBanco: 123456,
                numero: numero,
                tipoCartao: tipoCartaoSelecionado,
                dateVencimento: dataVencimento,
                agencia: agencia,
                codigoSeguranca: codigoSeguranca);

            final tipoCartao =
                cartao.tipoCartao == TipoCartao.DEBITO ? 'Débito' : 'Crédito';

            try {
              if (widget.cartaoParaEdicao != null) {
                cartao.id = widget.cartaoParaEdicao!.id;
                await _cartaoRepository.editarCartao(cartao);
              } else {
                await _cartaoRepository.cadastrarCartao(cartao);
              }

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Cartão de $tipoCartao cadastrado com sucesso'),
              ));

              Navigator.of(context).pop(true);
            } catch (e) {
              Navigator.of(context).pop(false);
            }
          }
        },
      ),
    );
  }

  TextFormField _buildNumero() {
    return TextFormField(
      controller: _numeroController,
      decoration: const InputDecoration(
        hintText: 'Informe o número do cartão',
        labelText: 'Número',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.numbers),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um número';
        }
        if (value.length < 16 || value.length > 16) {
          return 'Número de cartão deve ter 16 caracteres ';
        }
        return null;
      },
    );
  }

  TextFormField _buildAgencia() {
    return TextFormField(
      controller: _agenciaController,
      decoration: const InputDecoration(
        hintText: 'Informe o número da agência',
        labelText: 'Agência',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.account_balance),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma agência';
        }
        if (value.length != 4) {
          return 'Número da agência deve ter 4 caracteres ';
        }
        return null;
      },
    );
  }

  TextFormField _buildCodigoSeguranca() {
    return TextFormField(
      controller: _codigoSegurancaController,
      decoration: const InputDecoration(
        hintText: 'Informe o Código de segurança',
        labelText: 'Cód. segurança',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um código';
        }
        if (value.length != 3) {
          return 'Código de seguraça deve ter 3 números ';
        }
        return null;
      },
    );
  }

  TextFormField _buildBanco() {
    return TextFormField(
      controller: _bancoController,
      decoration: const InputDecoration(
        hintText: 'Informe o Banco',
        labelText: 'Banco',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.account_balance),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um banco';
        }
        return null;
      },
    );
  }

  TextFormField _buildDataVencimento() {
    return TextFormField(
      controller: _dataVencimentoController,
      decoration: const InputDecoration(
        hintText: 'Informe a Data de Vencimento',
        labelText: 'Data de vencimento',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.calendar_month),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());

        DateTime? dataSelecionada = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (dataSelecionada != null) {
          _dataVencimentoController.text =
              DateFormat('dd/MM/yyyy').format(dataSelecionada);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Data';
        }

        try {
          DateFormat('dd/MM/yyyy').parse(value);
        } on FormatException {
          return 'Formato de data inválida';
        }

        return null;
      },
    );
  }

  Widget _buildCreditoDebito() {
    return Column(
      children: <Widget>[
        RadioListTile<TipoCartao>(
          title: const Text('Crédito'),
          value: TipoCartao.CREDITO,
          groupValue: tipoCartaoSelecionado,
          onChanged: (TipoCartao? value) {
            if (value != null) {
              setState(() {
                tipoCartaoSelecionado = value;
              });
            }
          },
        ),
        RadioListTile<TipoCartao>(
          title: const Text('Débito'),
          value: TipoCartao.DEBITO,
          groupValue: tipoCartaoSelecionado,
          onChanged: (TipoCartao? value) {
            if (value != null) {
              setState(() {
                tipoCartaoSelecionado = value;
              });
            }
          },
        ),
      ],
    );
  }
}
