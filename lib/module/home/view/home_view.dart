import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/product/add_product/add_product_bloc.dart';
import 'package:flutter_ecatalog/bloc/product/get_products/products_bloc.dart';
import 'package:flutter_ecatalog/bloc/product/update_product/update_product_bloc.dart';
import 'package:flutter_ecatalog/core.dart';
import 'package:flutter_ecatalog/data/models/request/product_request_model.dart';
import 'package:flutter_ecatalog/module/home/controller/home_controller.dart';
import 'package:flutter_ecatalog/module/login/view/login_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  Widget build(context, HomeController controller) {
    controller.view = this;

    Widget _updateProduct({
      required int id,
      required String title,
      required int price,
      required String description,
    }) {
      return AlertDialog(
        title: const Text('Update Product'),
        content: Form(
          key: controller.formUpdateKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: controller.titleUpdateController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: controller.priceUpdateController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: controller.descriptionUpdateController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ]),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          const SizedBox(
            width: 5.0,
          ),
          BlocConsumer<UpdateProductBloc, UpdateProductState>(
            listener: (context, state) {
              if (state is UpdateProductLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product updated successfully')),
                );
                // Refresh the product list after the update
                controller.refresh(context);
                Navigator.pop(context);
              } else if (state is UpdateProductError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update product: ${state.message}'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update product'),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is UpdateProductLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ElevatedButton(
                onPressed: () {
                  if (controller.formUpdateKey.currentState!.validate()) {
                    controller.updateProduct(
                      context,
                      controller.titleUpdateController!.text,
                      int.parse(controller.priceUpdateController!.text),
                      controller.descriptionUpdateController!.text,
                      id,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update'),
              );
            },
          ),
        ],
      );
    }

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
                  final product = state.data.reversed.toList()[index];
                  return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          // update
                          return _updateProduct(
                            id: product.id!,
                            title: product.title ?? '',
                            price: product.price ?? 0,
                            description: product.description ?? '',
                          );
                        },
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(
                            state.data.reversed.toList()[index].title ?? '-'),
                        subtitle: Text('${state.data[index].price}\$'),
                        trailing: Text('${state.data[index].description}\$'),
                      ),
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
