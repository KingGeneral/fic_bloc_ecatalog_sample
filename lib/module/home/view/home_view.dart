import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/add_product/add_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/products/products_bloc.dart';
import 'package:flutter_ecatalog/core.dart';
import '../controller/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  Widget build(context, HomeController controller) {
    controller.view = this;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () async {
              await LocalDataSource().removeToken();
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const LoginView();
              }));
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                // reverse: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                          state.data.reversed.toList()[index].title ?? '-'),
                      subtitle: Text('${state.data[index].price}\$'),
                    ),
                  );
                },
                itemCount: state.data.length,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Product'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller.titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      TextField(
                        controller: controller.priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                      ),
                      TextField(
                        controller: controller.descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    const SizedBox(
                      width: 8,
                    ),
                    BlocConsumer<AddProductBloc, AddProductState>(
                      listener: (context, state) {
                        if (state is AddProductLoaded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Add Product Success')),
                          );
                          context.read<ProductsBloc>().add(GetProductsEvent());
                          controller.titleController!.clear();
                          controller.priceController!.clear();
                          controller.descriptionController!.clear();
                          Navigator.pop(context);
                        }
                        if (state is AddProductError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Add Product ${state.message}')),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AddProductLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton(
                            onPressed: () {
                              final model = ProductRequestModel(
                                title: controller.titleController!.text,
                                price:
                                    int.parse(controller.priceController!.text),
                                description:
                                    controller.descriptionController!.text,
                              );

                              context
                                  .read<AddProductBloc>()
                                  .add(DoAddProductEvent(model: model));
                            },
                            child: const Text('Add'));
                      },
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  State<HomeView> createState() => HomeController();
}
