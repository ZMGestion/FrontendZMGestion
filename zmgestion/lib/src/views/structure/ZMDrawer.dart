import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/widgets/ZMDrawer/CollapsingListTile.dart';
import 'package:zmgestion/src/widgets/ZMDrawer/NavigationModel.dart';
import 'package:zmgestion/src/widgets/ZMDrawer/SubCollapsingListTile.dart';

class ZMDrawer extends StatefulWidget {
  final BuildContext context;
  final double minWidth;
  final double maxWidth;

  const ZMDrawer({
    Key key,
    this.context,
    this.maxWidth = 300,
    this.minWidth = 70,
  }) : super(key: key);

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
  int currentSelectedIndex = 0;

  TextStyle listTitleDefaultTextStyle, listTitleSelectedTextStyle;
  List<NavigationModel> navigationItems;

  @override
  void initState() {
    super.initState();
    maxWidth = widget.maxWidth;
    minWidth = widget.minWidth;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
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
          title: "Presupuestos",
          icon: Icons.assignment,
          size: 32,
          animatedBuilder: AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return Column(children: [
                  SubCollapsingListTile(
                      title: 'Crear',
                      icon: Icons.edit,
                      animationController: _animationController,
                      width: 260, //maxwidth - 40
                      selectedTextStyle: listTitleDefaultTextStyle,
                      unselectedTextStyle: listTitleSelectedTextStyle,
                      onTap: () {
                        final NavigationService _navigationService =
                            locator<NavigationService>();
                        _navigationService.navigateTo("/presupuestos");
                      }),
                  SubCollapsingListTile(
                      title: 'Buscar',
                      icon: Icons.search,
                      isLast: true,
                      animationController: _animationController,
                      selectedTextStyle: listTitleDefaultTextStyle,
                      unselectedTextStyle: listTitleSelectedTextStyle,
                      width: 260, //maxwidth - 40
                      onTap: () {})
                ]);
              })),
      NavigationModel(title: "Ventas", icon: Icons.payment, size: 32),
      NavigationModel(title: "Remitos", icon: Icons.local_shipping, size: 32),
      NavigationModel(
          title: "Produccion", icon: FontAwesomeIcons.hammer, size: 26),
      NavigationModel(
          title: "Productos", icon: Icons.weekend, size: 32), //Icons.style
      NavigationModel(title: "Reportes", icon: Icons.insert_chart, size: 32),
      NavigationModel(
          title: "Ubicaciones", icon: Icons.location_city, size: 32),
      NavigationModel(
          title: "Empleados",
          icon: Icons.people,
          size: 32,
          animatedBuilder: AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return Column(children: [
                  SubCollapsingListTile(
                      title: 'Crear',
                      icon: Icons.edit,
                      animationController: _animationController,
                      width: 260, //maxwidth - 40
                      selectedTextStyle: listTitleDefaultTextStyle,
                      unselectedTextStyle: listTitleSelectedTextStyle,
                      onTap: () {
                        final NavigationService _navigationService =
                            locator<NavigationService>();
                        _navigationService.navigateTo("/clientes");
                      }),
                  SubCollapsingListTile(
                      title: 'Buscar',
                      icon: Icons.search,
                      isLast: true,
                      animationController: _animationController,
                      selectedTextStyle: listTitleDefaultTextStyle,
                      unselectedTextStyle: listTitleSelectedTextStyle,
                      width: 260, //maxwidth - 40
                      onTap: () {
                        final NavigationService _navigationService =
                            locator<NavigationService>();
                        _navigationService.navigateTo("/usuarios");
                      })
                ]);
              })),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => getWidget(context, widget),
    );
  }

  Widget getWidget(context, widget) {
    return Material(
      elevation: 80.0,
      color: Theme.of(context).primaryColor,
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
              CollapsingListTile(
                title: 'Silvia Carolina Zimmerman',
                icon: Icons.person,
                animationController: _animationController,
                selectedTextStyle: listTitleDefaultTextStyle,
                unselectedTextStyle: listTitleSelectedTextStyle,
                width: maxWidth - 40,
              ),
              Divider(
                color: Colors.grey,
                height: 40.0,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, counter) {
                    return Divider(height: 12.0);
                  },
                  itemBuilder: (context, counter) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        /*onHover: (h){
                            if(h){
                              setState(() {
                                currentSelectedIndex = counter;
                              });
                            }
                          },*/
                        /*
                          onEnter: (_){
                            setState(() {
                              currentSelectedIndex = counter;
                            });
                          },
                          onExit: (_){
                            if(currentSelectedIndex == counter){
                              setState(() {
                                currentSelectedIndex = -1;
                              });
                            }
                          },
                          */
                        onTap: () {},
                        child: Column(
                          children: [
                            CollapsingListTile(
                              onTap: () {
                                setState(() {
                                  if (!(currentSelectedIndex == counter)) {
                                    currentSelectedIndex = counter;
                                  } else {
                                    currentSelectedIndex = -1;
                                  }
                                });
                              },
                              width: maxWidth - 40,
                              selectedTextStyle: listTitleDefaultTextStyle,
                              unselectedTextStyle: listTitleSelectedTextStyle,
                              isSelected: currentSelectedIndex == counter,
                              title: navigationItems[counter].title,
                              icon: navigationItems[counter].icon,
                              iconSize: navigationItems[counter].size,
                              animationController: _animationController,
                            ),
                            Visibility(
                              visible: currentSelectedIndex == counter,
                              child: navigationItems[counter].animatedBuilder !=
                                      null
                                  ? navigationItems[counter].animatedBuilder
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: navigationItems.length,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isCollapsed = !isCollapsed;
                    isCollapsed
                        ? _animationController.forward()
                        : _animationController.reverse();
                  });
                },
                child: AnimatedIcon(
                  icon: AnimatedIcons.close_menu,
                  progress: _animationController,
                  color: Theme.of(context).primaryTextTheme.caption.color,
                  size: 40.0,
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
