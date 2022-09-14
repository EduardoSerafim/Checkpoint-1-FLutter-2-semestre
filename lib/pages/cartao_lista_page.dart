import 'package:financas_pessoais/components/cartao_lista_item.dart';
import 'package:financas_pessoais/models/cartao.dart';
import 'package:financas_pessoais/pages/cartao_cadastro_page.dart';
import 'package:financas_pessoais/repository/cartao_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartaoListaPage extends StatefulWidget {
  const CartaoListaPage({Key? key}) : super(key: key);

  @override
  State<CartaoListaPage> createState() => _CartaoListaPageState();
}

class _CartaoListaPageState extends State<CartaoListaPage> {
  final _cartaoRepository = CartaoRepository();
  late Future<List<Cartao>> _futureCartoes;

  @override
  void initState() {
    carregarCartoes();
    super.initState();
  }

  void carregarCartoes() {
    _futureCartoes = _cartaoRepository.listarCartoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cartões')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder<List<Cartao>>(
          future: _futureCartoes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final cartoes = snapshot.data ?? [];
              return ListView.separated(
                itemCount: cartoes.length,
                itemBuilder: (context, index) {
                  final cartao = cartoes[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            await _cartaoRepository
                                .removerCartao(cartao.id!);

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Cartão removido com sucesso')));

                            setState(() {
                              cartoes.removeAt(index);
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Remover',
                        ),
                        SlidableAction(
                          onPressed: (context) async {
                            var success = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CartaoCadastroPage(
                                  cartaoParaEdicao: cartao,
                                ),
                              ),
                            ) as bool?;

                            if (success != null && success) {
                              setState(() {
                                carregarCartoes();
                              });
                            }
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Editar',
                        ),
                      ],
                    ),
                    
                    child: CartaoListaItem(cartao: cartao),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? cartaoCadastrado = await Navigator.of(context)
                .pushNamed('/cartao-cadastro') as bool?;

            if (cartaoCadastrado != null && cartaoCadastrado) {
              setState(() {
                carregarCartoes();
              });
            }
          },
          child: const Icon(Icons.add)),
    );
  }
}
