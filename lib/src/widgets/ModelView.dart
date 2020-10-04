import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Paginaciones.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/Services.dart';
import 'package:zmgestion/src/shimmers/DefaultShimmer.dart';
import 'package:zmgestion/src/widgets/LoadingWidget.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

/*
import 'package:parko/src/common/Appearance.dart';
import 'package:parko/src/common/LoadingWidget.dart';
import 'package:parko/src/common/Request.dart';
import 'package:parko/src/common/common.dart';
import 'package:parko/src/Services/Services.dart';
import 'package:parko/src/models/Models.dart';
import 'package:parko/src/shimmers/DefaultShimmer.dart';
import 'package:shimmer/shimmer.dart';
*/

class ModelView extends StatefulWidget {
  final Services service;
  final bool isList;
  final bool nestedScroll;
  final bool horizontalScroll;
  final Widget Function(Map<String, dynamic> mapModel, int index,
      StreamController<ItemAction> itemsController) itemBuilder;
  final ListMethodConfiguration listMethodConfiguration;
  final GetMethodConfiguration getMethodConfiguration;
  final bool showAnimatedLoading;
  final String errorMessage;
  final String assetPath;
  final Function(List<Models> resultSet) onComplete;
  final Function(
          Map<String, List<dynamic>> categorized, List<dynamic> unCategorized)
      onCategorizeComplete;
  final Function onEmpty;
  final Function(Function retryAction) onError;
  final bool errorImage;
  final bool smartRefresher;
  final Widget animatedLoading;
  final bool retryButton;
  final bool shimmer;
  final Map<String, bool Function(Map<String, dynamic>)> categorize;
  final Map<String, ListConfiguration> categorizedListConfiguration;
  final ListConfiguration uncategorizedListConfiguration;
  final String uncategorizedTitle;
  final bool showUncategorized;
  final Function(Paginaciones pageInfo) onPageInfo;

  /**
   * Ejemplo de categorize:
   *
   * categorize: {
   *   "pendientes": (mapModel){
   *      return mapModel["estado"] == "P";
   *   }
   * }
   *
   * */

  const ModelView(
      {Key key,
      this.service,
      this.isList,
      this.nestedScroll = false,
      this.horizontalScroll = false,
      this.itemBuilder,
      this.listMethodConfiguration,
      this.getMethodConfiguration,
      this.showAnimatedLoading,
      this.errorMessage,
      this.assetPath = "assets/sadComputer.png",
      this.onComplete,
      this.onCategorizeComplete,
      this.onEmpty,
      this.onError,
      this.errorImage,
      this.smartRefresher = true,
      this.animatedLoading,
      this.retryButton = true,
      this.shimmer = true,
      this.categorize,
      this.categorizedListConfiguration,
      this.uncategorizedListConfiguration,
      this.uncategorizedTitle,
      this.showUncategorized,
      this.onPageInfo})
      : assert(itemBuilder != null || categorizedListConfiguration != null),
        assert(onComplete == null || onCategorizeComplete == null),
        super(key: key);

  @override
  _ModelViewState createState() => _ModelViewState();
}

class ItemAction {
  final ItemEvents event;
  final int index;
  final GetMethodConfiguration updateMethodConfiguration;

  ItemAction({this.event, this.index, this.updateMethodConfiguration});
}

enum ItemEvents { Hide, Update }

class _ModelViewState extends State<ModelView> {
  bool loading = true;
  Object result;
  bool closed = false;
  bool hasError = false;
  List<Models> modelsList;
  Map<String, dynamic> mapModelsList = {};
  StreamController<ItemAction> itemsController = StreamController<ItemAction>();
  ScrollController scrollController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    closed = true;
    itemsController.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    itemsController.stream.listen((itemAction) async {
      if (modelsList != null && itemAction != null) {
        if (itemAction.event != null && itemAction.index != null) {
          if (itemAction.index >= 0) {
            switch (itemAction.event) {
              case ItemEvents.Hide:
                setState(() {
                  modelsList.removeAt(itemAction.index);
                });
                break;
              case ItemEvents.Update:
                if (itemAction.updateMethodConfiguration != null) {
                  await widget.service
                      .damePor(itemAction.updateMethodConfiguration)
                      .then((response) async {
                    if (!closed) {
                      if (response.status == RequestStatus.SUCCESS) {
                        setState(() {
                          modelsList[itemAction.index] = response.message;
                        });
                      }
                    }
                  });
                }
                break;
              default:
                break;
            }
          }
        }
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await loadModel();
    });
  }

  /*
    @override
    void setState(VoidCallback fn){
      if(modelsList != null){
        mapModelsList.clear();
        modelsList.forEach((model) {
          mapModelsList.addAll(model.toMap());
        });
      }
      super.setState(fn);
    }
    */

  _addNestedList(List<Widget> toList, List<dynamic> lista,
      ListConfiguration configuration) {
    if (lista.length > 0) {
      if (configuration.parentWidget != null) {
        toList.add(configuration.parentWidget(_NestedList(
          list: lista,
          config: configuration,
        )));
      } else {
        toList.add(_NestedList(
          list: lista,
          config: configuration,
        ));
      }
    } else {
      if (configuration.onEmpty != null) {
        Widget _emptyWidget = Column(
          children: <Widget>[
            Visibility(
                visible: configuration.title != null,
                child: _NestedListTitle(configuration)),
            Visibility(
              visible: configuration.onEmpty != null,
              child: configuration.onEmpty != null
                  ? configuration.onEmpty
                  : Container(),
            )
          ],
        );
        if (configuration.parentWidget != null) {
          toList.add(configuration.parentWidget(_emptyWidget));
        } else {
          toList.add(_emptyWidget);
        }
      } else {
        toList.add(Container());
      }
    }
  }

  ListConfiguration _defaultConfiguration(String title) {
    ListConfiguration configuracion = ListConfiguration(
      itemBuilder: widget.itemBuilder,
    );

    configuracion.title = title;

    return configuracion;
  }

  Future<void> loadModel() async {
    if (widget.isList) {
      await widget.service
          .listMethod(widget.listMethodConfiguration)
          .then((response) {
        if (!closed) {
          if (response.status == RequestStatus.SUCCESS) {
            if (widget.onComplete != null) {
              widget.onComplete(response.message);
            }
          }
          if (response.pageInfo != null) {
            if (widget.onPageInfo != null) {
              widget.onPageInfo(response.pageInfo);
            }
          }
          setState(() {
            this.result = response.message;
            hasError = (response.status == RequestStatus.ERROR);
            loading = false;
            modelsList = this.result;
          });
        }
      });
    } else {
      await widget.service
          .damePor(widget.getMethodConfiguration)
          .then((response) {
        if (!closed) {
          if (response.status == RequestStatus.SUCCESS) {
            if (widget.onComplete != null) {
              widget.onComplete([response.message]);
            }
          }
          setState(() {
            this.result = response.message;
            hasError = (response.status == RequestStatus.ERROR);
            loading = false;
          });
        }
      });
    }
  }

  Widget _onEmpty() {
    if (widget.onEmpty != null) {
      return widget.onEmpty();
    } else {
      return Container();
    }
  }

  void retryAction() async {
    setState(() {
      loading = true;
    });
    await loadModel();
  }

  Widget _NestedListTitle(ListConfiguration config) {
    if (config.titleWidget != null) {
      return config.titleWidget(config.title);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              config.title != null ? config.title : "",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                  fontSize: 16),
            ),
          )
        ],
      );
    }
  }

  Widget _NestedList({List<dynamic> list, ListConfiguration config}) {
    return Column(
      children: <Widget>[
        Visibility(
            visible: config.title != null, child: _NestedListTitle(config)),
        ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shrinkWrap: true,
          //implementar scrollDirection
          itemBuilder: (context, index) {
            if (config.itemBuilder != null) {
              return config.itemBuilder(
                  list.elementAt(index), index, itemsController);
            }
            return widget.itemBuilder(
                list.elementAt(index), index, itemsController);
          },
          physics: config.nestedScroll ? ClampingScrollPhysics() : null,
        )
      ],
    );
  }

  Widget _onError() {
    if (widget.onError != null) {
      return widget.onError(retryAction);
    } else {
      return LayoutBuilder(builder: (context, constraints) {
        double fullWidth = constraints.biggest.width;
        return Container(
          width: fullWidth,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: <Widget>[
                Visibility(
                    visible: widget.retryButton,
                    child: Opacity(
                      opacity: 0.7,
                      child: Container(
                        height: SizeConfig.blockSizeVertical * 18,
                        child: Image(
                          image: AssetImage(widget.assetPath),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  child: Text(widget.errorMessage != null
                      ? widget.errorMessage
                      : "Ups! Ha ocurrido un problema. Por favor, vuelva a intentarlo."),
                ),
                Visibility(
                    visible: widget.retryButton,
                    child: MaterialButton(
                      onPressed: retryAction,
                      child: Text(
                        "Reintentar",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ))
              ],
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (loading) {
      if (widget.shimmer) {
        if (widget.animatedLoading != null) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).backgroundColor.withOpacity(0.3),
            highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
            period: Duration(milliseconds: 1250),
            child: widget.animatedLoading,
          );
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            child: Center(child: LoadingWidget()),
          );
          //return DefaultShimmer();
        }
      } else {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(child: LoadingWidget()),
        );
      }
    } else {
      if (hasError) {
        return _onError();
      } else {
        if (widget.isList) {
          setState(() {
            modelsList = result;
          });
          if (modelsList != null) {
            if (modelsList.length > 0) {
              if (widget.categorize != null) {
                Map<String, List<dynamic>> categorizedResult = {};
                List<dynamic> uncategorized = [];
                bool categorized = false;
                modelsList.forEach((model) {
                  categorized = false;
                  widget.categorize
                      .forEach((categorizeKey, categorizeFunction) {
                    if (!categorizedResult.containsKey(categorizeKey)) {
                      categorizedResult.addAll({categorizeKey: []});
                    }
                    if (!categorized) {
                      if (categorizeFunction(model.toMap())) {
                        categorizedResult[categorizeKey].add(model.toMap());
                        categorized = true;
                      }
                    }
                  });
                  if (!categorized) {
                    uncategorized.add(model.toMap());
                  }
                });
                if (widget.onCategorizeComplete != null) {
                  widget.onCategorizeComplete(categorizedResult, uncategorized);
                }

                List<Widget> nestedLists = [];

                //Mostramos los que fueron categorizados segun tenga o no configuracion
                widget.categorize.keys.forEach((categoria) {
                  if (widget.categorizedListConfiguration != null) {
                    widget.categorizedListConfiguration
                        .forEach((nombreCategoria, configuracion) {
                      configuracion.title = nombreCategoria;
                      if (nombreCategoria == categoria) {
                        _addNestedList(nestedLists,
                            categorizedResult[categoria], configuracion);
                      } else {
                        _addNestedList(
                            nestedLists,
                            categorizedResult[categoria],
                            _defaultConfiguration(categoria));
                      }
                    });
                  } else {
                    _addNestedList(nestedLists, categorizedResult[categoria],
                        _defaultConfiguration(categoria));
                  }
                });

                if (widget.showUncategorized) {
                  //Mostramos los no categorizados segun tenga o no configuracion
                  if (widget.uncategorizedListConfiguration != null) {
                    widget.uncategorizedListConfiguration.title =
                        widget.uncategorizedTitle;
                    _addNestedList(nestedLists, uncategorized,
                        widget.uncategorizedListConfiguration);
                  } else {
                    _addNestedList(nestedLists, uncategorized,
                        _defaultConfiguration(widget.uncategorizedTitle));
                  }
                }

                return CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Column(
                          children: nestedLists,
                        )
                      ]),
                    )
                  ],
                );
              }
              return Scrollbar(
                controller: scrollController,
                isAlwaysShown: true,
                child: ListView.builder(
                  controller: scrollController,
                  key: Key(modelsList.length.toString()),
                  itemCount: modelsList.length,
                  itemBuilder: (context, index) {
                    return widget.itemBuilder(
                        modelsList.elementAt(index).toMap(),
                        index,
                        itemsController);
                  },
                  shrinkWrap: true,
                  physics: widget.nestedScroll
                      ? ClampingScrollPhysics()
                      : ScrollPhysics(),
                  scrollDirection:
                      widget.horizontalScroll ? Axis.horizontal : Axis.vertical,
                ),
              );
            } else {
              return _onEmpty();
            }
          } else {
            return _onEmpty();
          }
        } else {
          Models model = result;
          if (model == null) {
            return _onEmpty();
          } else {
            return widget.itemBuilder(model.toMap(), 0, null);
          }
        }
      }
    }
  }
}

class ListConfiguration {
  final Widget Function(Map<String, dynamic> mapModel, int index,
      StreamController<ItemAction> itemsController) itemBuilder;
  final Widget Function(Widget childWidget) parentWidget;
  final Widget onEmpty;
  final bool horizontalScroll;
  final bool
      nestedScroll; //true significa que el scroll sera controlado por el scroll general y no por si mismo.
  final bool showTitle;
  final Widget Function(String title) titleWidget;
  String title;

  ListConfiguration(
      {this.itemBuilder,
      this.parentWidget,
      this.onEmpty,
      this.horizontalScroll = false,
      this.nestedScroll = true,
      this.showTitle,
      this.titleWidget});
}
