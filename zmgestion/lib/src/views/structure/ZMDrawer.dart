import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/providers/UsuariosProvider.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/ZMDrawer/CollapsingListTile.dart';
import 'package:zmgestion/src/widgets/ZMDrawer/NavigationModel.dart';
import 'package:zmgestion/src/widgets/ZMDrawer/SubCollapsingListTile.dart';

class ZMDrawer extends StatefulWidget {
  final BuildContext context;
  final double minWidth;
  final double maxWidth;

  const ZMDrawer(
      {Key key, this.context, this.maxWidth = 300, this.minWidth = 70})
      : super(key: key);

  @override
  ZMDrawerState createState() {
    return new ZMDrawerState();
  }
}

class ZMDrawerState extends State<ZMDrawer>
    with SingleTickerProviderStateMixin {
  double maxWidth;
  double minWidth;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = -1;

  TextStyle listTitleDefaultTextStyle, listTitleSelectedTextStyle;
  List<NavigationModel> navigationItems;

  @override
  void initState() {
    maxWidth = widget.maxWidth;
    minWidth = widget.minWidth;

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController);

    listTitleDefaultTextStyle = TextStyle(
        color: Theme.of(widget.context)
            .primaryTextTheme
            .caption
            .color
            .withOpacity(0.7),
        fontSize: 14.0,
        fontWeight: FontWeight.w600);
    listTitleSelectedTextStyle = TextStyle(
        color: Theme.of(widget.context).primaryTextTheme.caption.color,
        fontSize: 14.0,
        fontWeight: FontWeight.w600);
    navigationItems = [
      NavigationModel(
          title: "Inicio",
          icon: Icons.home,
          size: 32,
          onTap: () {
            final NavigationService _navigationService =
                locator<NavigationService>();
            _navigationService.navigateTo("/inicio");
          }),
      NavigationModel(
          title: "Presupuestos",
          icon: Icons.assignment,
          size: 32,
          onTap: () {
            final NavigationService _navigationService =
                locator<NavigationService>();
            _navigationService.navigateTo("/presupuestos");
          }),
      NavigationModel(
          title: "Ventas",
          icon: Icons.payment,
          size: 32,
          onTap: () {
            final NavigationService _navigationService =
                locator<NavigationService>();
            _navigationService.navigateTo("/ventas");
          }),
      NavigationModel(
          title: "Remitos",
          icon: Icons.local_shipping,
          size: 32,
          onTap: () {
            final NavigationService _navigationService =
                locator<NavigationService>();
            _navigationService.navigateTo("/remitos");
          }),
      NavigationModel(
          title: "Produccion",
          icon: FontAwesomeIcons.hammer,
          size: 26,
          onTap: () {
            final NavigationService _navigationService =
                locator<NavigationService>();
            _navigationService.navigateTo("/ordenes-produccion");
          }),
      NavigationModel(
          title: "Clientes",
          icon: FontAwesomeIcons.users, //Icons.face,
          size: 23,
          onTap: () {
            final NavigationService _navigationService =
                locator<NavigationService>();
            _navigationService.navigateTo("/clientes");
          }),
      NavigationModel(
          title: "Artículos",
          icon: Icons.local_offer, //FontAwesomeIcons.archive
          size: 22,
          animatedBuilder: AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return Column(children: [
                  SubCollapsingListTile(
                    title: 'Muebles',
                    icon: Icons.weekend,
                    animationController: _animationController,
                    width: widget.maxWidth - 40, //maxwidth - 40
                    selectedTextStyle: listTitleDefaultTextStyle,
                    unselectedTextStyle: listTitleSelectedTextStyle,
                    onTap: () {
                      final NavigationService _navigationService =
                          locator<NavigationService>();
                      _navigationService.navigateTo("/productos-finales");
                    },
                  ),
                  SubCollapsingListTile(
                    title: 'Productos',
                    icon: FontAwesomeIcons.boxOpen,
                    iconSize: 17,
                    animationController: _animationController,
                    width: widget.maxWidth - 40, //maxwidth - 40
                    selectedTextStyle: listTitleDefaultTextStyle,
                    unselectedTextStyle: listTitleSelectedTextStyle,
                    onTap: () {
                      final NavigationService _navigationService =
                          locator<NavigationService>();
                      _navigationService.navigateTo("/productos");
                    },
                  ),
                  SubCollapsingListTile(
                    title: 'Telas',
                    icon: FontAwesomeIcons.buffer,
                    iconSize: 19,
                    animationController: _animationController,
                    width: widget.maxWidth - 40, //maxwidth - 40
                    selectedTextStyle: listTitleDefaultTextStyle,
                    unselectedTextStyle: listTitleSelectedTextStyle,
                    onTap: () {
                      final NavigationService _navigationService =
                          locator<NavigationService>();
                      _navigationService.navigateTo("/telas");
                    },
                    isLast: true,
                  )
                ]);
              })),
      NavigationModel(
        title: "Empleados",
        icon: Icons.work,
        size: 30,
        onTap: () {
          final NavigationService _navigationService =
              locator<NavigationService>();
          _navigationService.navigateTo("/usuarios");
        },
      ),
      NavigationModel(
        title: "Reportes",
        icon: Icons.insert_chart,
        size: 32,
        onTap: () {},
      ),
      NavigationModel(
        title: "Ubicaciones",
        icon: Icons.pin_drop,
        size: 32,
        onTap: () {
          final NavigationService _navigationService =
              locator<NavigationService>();
          _navigationService.navigateTo("/ubicaciones");
        },
      ),
      NavigationModel(
        title: "Roles",
        icon: Icons.supervised_user_circle,
        size: 32,
        onTap: () {
          final NavigationService _navigationService =
              locator<NavigationService>();
          _navigationService.navigateTo("/roles");
        },
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => Positioned(
          top: 0,
          left: 0,
          width: widthAnimation.value,
          height: SizeConfig.blockSizeVertical * 100,
          child: getWidget(context, widget)),
    );
  }

  Widget getWidget(context, widget) {
    final UsuariosProvider _usuariosProvider =
        Provider.of<UsuariosProvider>(context);
    Usuarios usuario = _usuariosProvider.usuario;
    return Material(
      elevation: 2.5,
      color: Theme.of(context).primaryColor.withOpacity(0.97),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isCollapsed = !isCollapsed;
            isCollapsed
                ? _animationController.forward()
                : _animationController.reverse();
          });
        },
        child: Container(
          width: widthAnimation.value,
          child: Column(
            children: <Widget>[
              Material(
                color: Theme.of(context).primaryColor,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .caption
                                  .color
                                  .withOpacity(0.1)))),
                  child: CollapsingListTile(
                    title: "ZMGestion",
                    leading: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AnimatedIcon(
                        icon: AnimatedIcons.close_menu,
                        progress: _animationController,
                        color: Theme.of(context).primaryTextTheme.caption.color,
                        size: 32.0,
                      ),
                    ),
                    animationController: _animationController,
                    isSelected: false,
                    selectedTextStyle: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .caption
                            .color
                            .withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                    unselectedTextStyle: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .caption
                            .color
                            .withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                    width: maxWidth - 40,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isCollapsed = !isCollapsed;
                      isCollapsed
                          ? _animationController.forward()
                          : _animationController.reverse();
                    });
                  },
                  child: SizedBox(
                    height: 40.0,
                    width: maxWidth,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, counter) {
                    return InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {},
                      child: Column(
                        children: [
                          CollapsingListTile(
                            onTap: () {
                              if (navigationItems[counter].onTap != null) {
                                navigationItems[counter].onTap();
                              } else {
                                setState(() {
                                  if (!(currentSelectedIndex == counter)) {
                                    currentSelectedIndex = counter;
                                  } else {
                                    currentSelectedIndex = -1;
                                  }
                                });
                              }
                            },
                            width: maxWidth - 40,
                            selectedTextStyle: listTitleDefaultTextStyle,
                            unselectedTextStyle: listTitleSelectedTextStyle,
                            isSelected: currentSelectedIndex == counter,
                            title: navigationItems[counter].title,
                            icon: navigationItems[counter].icon,
                            iconSize: navigationItems[counter].size,
                            animationController: _animationController,
                            expandable:
                                navigationItems[counter].animatedBuilder !=
                                    null,
                          ),
                          Visibility(
                            visible: currentSelectedIndex == counter,
                            child:
                                navigationItems[counter].animatedBuilder != null
                                    ? navigationItems[counter].animatedBuilder
                                    : Container(),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: navigationItems.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
