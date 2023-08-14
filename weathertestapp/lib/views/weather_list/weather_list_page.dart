import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weathertestapp/models/app_state.dart';
import 'package:weathertestapp/models/dtos/weather_dto.dart';
import 'package:weathertestapp/views/weather_list/weather_list_view_model.dart';

class WeatherListPage extends StatefulWidget {
  final WeatherListViewModel viewModel;

  const WeatherListPage({super.key, required this.viewModel});

  @override
  State<WeatherListPage> createState() => _WeatherListPageState();
}

class _WeatherListPageState extends State<WeatherListPage> {
  late TextEditingController editingController;
  final StreamController streamController = StreamController.broadcast();
  @override
  void initState() {
    super.initState();
    editingController = TextEditingController();

    // streamController.stream
    //     .distinct()
    //     .debounceTime(const Duration(milliseconds: 700))
    //     .listen((text) {
    //   widget.viewModel.searchByCityName(text);
    // });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      widget.viewModel.loadData().then((value) => null);
    });
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: editingController,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(
                editingController.text.isEmpty ? Icons.search : Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                editingController.clear();
                setState(() {});
              },
            ),
            suffixIcon: editingController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      widget.viewModel.searchByCityName(editingController.text);
                    },
                  )
                : null,
            hintText: 'Search by name city',
          ),
          onChanged: (text) {
            setState(() {});
          },
        ),
      ),
      body: AnimatedBuilder(
          animation: widget.viewModel,
          builder: (context, snapshot) {
            final data = widget.viewModel.value;
            if (data is LoadingAppState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (data is FailureAppState) {
              return Center(
                child: Text(data.message ?? ''),
              );
            }

            if (data is SuccessAppState) {
              final items = data as SuccessAppState<List<WeatherItemDto>>;
              return ListView.separated(
                itemBuilder: (context, index) {
                  final item = items.data[index];

                  return ListTile(
                    title: Row(
                      children: [
                        Text(item.cityName),
                        const SizedBox(width: 8),
                        Text('${item.temperatury}ºC'),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, i) => const SizedBox(height: 8),
                itemCount: items.data.length,
              );
            }

            return Center(
              child: Text(data.message ?? ''),
            );
          }),
    );
  }
}
