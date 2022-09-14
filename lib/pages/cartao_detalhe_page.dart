import 'package:financas_pessoais/models/cartao.dart';
import 'package:financas_pessoais/models/tipo_cartao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartaoDetalhePage extends StatelessWidget {
  const CartaoDetalhePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartao = ModalRoute.of(context)!.settings.arguments as Cartao;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do cartão"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Tipo do cartão'),
              subtitle: Text(cartao.tipoCartao == TipoCartao.DEBITO
                  ? 'Débito'
                  : 'Crédito'),
            ),
            ListTile(
              title: const Text('Número do cartão'),
              subtitle: Text(cartao.montarNumeroCartao())
            ),
            ListTile(
              title: const Text('Data de Vencimento'),
              subtitle: Text(DateFormat('MM/yyyy').format(cartao.dateVencimento)),
            ),
            ListTile(
              title: const Text('Banco'),
              subtitle: Text("Banco"),
            ),
            ListTile(
              title: const Text('Agência'),
              subtitle: Text(cartao.agencia.toString()),
            ),
            ListTile(
              title: const Text('Conta'),
              subtitle: Text("conta"),
            ),
            ListTile(
              title: const Text('Código de segurança'),
              subtitle: Text(cartao.codigoSeguranca.toString()),
            ),
          ],
        ),
      ),
    );
  }
}


