import 'package:flutter/material.dart';
TextStyle listTitleDefaultTextStyle = TextStyle(color: Colors.white70, fontSize: 14.0, fontWeight: FontWeight.w600);
TextStyle listTitleSelectedTextStyle = TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600);
Color selectedColor = Color(0xFFFFFFFF);
Color drawerBackgroundColor = Color(0xFF272D34);


class ZMDrawer extends StatefulWidget {
  final double minWidth;
  final double maxWidth;

  const ZMDrawer({
    Key key, 
    this.maxWidth,
    this.minWidth = 70,
  }) : super(key: key);


  @override
  ZMDrawerState createState() {
    return new ZMDrawerState();
  }
}

class ZMDrawerState extends State<ZMDrawer> with SingleTickerProviderStateMixin {
  double maxWidth = 300;
  double minWidth = 70;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    maxWidth = widget.maxWidth;
    minWidth = widget.minWidth;
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController);
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
          onTap: (){
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
                width: maxWidth - 40,
              ),
              Divider(color: Colors.grey, height: 40.0,),
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
                          onHover: (h){
                            if(h){
                              setState(() {
                                currentSelectedIndex = counter;
                              });
                            }
                          },
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
                          onTap: (){},
                          child: Column(
                          children: [
                            CollapsingListTile(
                                onTap: () {
                                  setState(() {
                                    if(!(currentSelectedIndex == counter)){
                                      currentSelectedIndex = counter;
                                    }else{
                                      currentSelectedIndex = -1;
                                    }
                                    
                                  });
                                },
                                width: maxWidth - 40,
                                isSelected: currentSelectedIndex == counter,
                                title: navigationItems[counter].title,
                                icon: navigationItems[counter].icon,
                                animationController: _animationController,
                            ),
                            Visibility(
                                visible: currentSelectedIndex == counter,
                                child: Column(
                                  children: [
                                    SubCollapsingListTile(
                                      title: 'Crear',
                                      icon: Icons.edit, 
                                      animationController: _animationController,
                                      width: maxWidth - 40,
                                      onTap: (){}
                                    ),
                                    SubCollapsingListTile(
                                      title: 'Buscar', 
                                      icon: Icons.search, 
                                      isLast: true,
                                      animationController: _animationController,
                                      width: maxWidth - 40,
                                      onTap: (){}
                                    ),
                                  ],
                                ),
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
                  color: selectedColor,
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

class CollapsingListTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;
  final double width;

  CollapsingListTile(
      {@required this.title,
      @required this.icon,
      @required this.width,
      @required this.animationController,
      this.isSelected = false,
      this.onTap});

  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
}

class _CollapsingListTileState extends State<CollapsingListTile> {
  Animation<double> widthAnimation, sizedBoxAnimation;

  @override
  void initState() {
    super.initState();
    widthAnimation =
        Tween<double>(begin: widget.width, end: 70).animate(widget.animationController);
    sizedBoxAnimation =
        Tween<double>(begin: 10, end: 0).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          color: widget.isSelected
              ? Colors.transparent.withOpacity(0.1)
              : Colors.transparent,
        ),
        width: widthAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: (widthAnimation.value >= 190) ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              widget.icon,
              color: widget.isSelected ? selectedColor : Colors.white30,
              size: 33.0,
            ),
            SizedBox(width: sizedBoxAnimation.value),
            (widthAnimation.value >= 190)
                ? Text(widget.title,
                    style: widget.isSelected
                        ? listTitleSelectedTextStyle
                        : listTitleDefaultTextStyle)
                : Container()
          ],
        ),
      ),
    );
  }
}

class SubCollapsingListTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;
  final double width;
  final bool isLast;

  SubCollapsingListTile(
      {@required this.title,
      @required this.icon,
      @required this.width,
      @required this.animationController,
      this.isLast = false,
      this.isSelected = false,
      this.onTap});

  @override
  _SubCollapsingListTileState createState() => _SubCollapsingListTileState();
}

class _SubCollapsingListTileState extends State<SubCollapsingListTile> {
  Animation<double> widthAnimation, sizedBoxAnimation;

  @override
  void initState() {
    super.initState();
    widthAnimation =
        Tween<double>(begin: widget.width, end: 70).animate(widget.animationController);
    sizedBoxAnimation =
        Tween<double>(begin: 10, end: 0).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.isLast ? BorderRadius.vertical(bottom: Radius.circular(16)) : null,
          color: widget.isSelected
              ? Colors.transparent.withOpacity(0.3)
              : Colors.transparent.withOpacity(0.05),
        ),
        width: widthAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: (widthAnimation.value >= 190) ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black12
              ),
              child: Icon(
                widget.icon,
                color: widget.isSelected ? selectedColor : Colors.white24,
                size: 20.0,
              ),
            ),
            SizedBox(width: sizedBoxAnimation.value),
            (widthAnimation.value >= 190)
                ? Text(widget.title,
                    style: widget.isSelected
                        ? listTitleSelectedTextStyle
                        : listTitleDefaultTextStyle)
                : Container()
          ],
        ),
      ),
    );
  }
}

class NavigationModel {
  String title;
  IconData icon;
  NavigationModel({this.title, this.icon});
}
List<NavigationModel> navigationItems = [
  NavigationModel(title: "Presupuestos", icon: Icons.description),
  NavigationModel(title: "Ventas", icon: Icons.payment),
  NavigationModel(title: "Remitos", icon: Icons.local_shipping),
  NavigationModel(title: "Produccion", icon: Icons.domain),
  NavigationModel(title: "Productos", icon: Icons.weekend), //Icons.style
  NavigationModel(title: "Reportes", icon: Icons.settings),
  NavigationModel(title: "Ubicaciones", icon: Icons.settings),
  NavigationModel(title: "Empleados", icon: Icons.people)
];