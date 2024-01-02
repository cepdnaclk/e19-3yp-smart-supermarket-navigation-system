import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({Key? key}):super(key: key);

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

@override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 1200;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen ? AppBar(
              backgroundColor: canvasColor,
              title: const Text('Shop Wise',style: TextStyle(color: scaffoldBackgroundColor,fontSize: 20),),
              leading: IconButton(
                onPressed: (){
                  _key.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu,color: scaffoldBackgroundColor,),
              ),
            ): null,
            drawer: SideBarXExample(controller: _controller,),
            body: Row(
              children: [
                if(!isSmallScreen) SideBarXExample(controller: _controller),
                Expanded(child: Center(child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context,child){
                    switch(_controller.selectedIndex){
                      case 0: _key.currentState?.closeDrawer();
                      return const Center(
                        child: Text('Home',style: TextStyle(color: Color.fromARGB(255, 247, 59, 59),fontSize: 40),),
                      );
                      case 1: _key.currentState?.closeDrawer();
                      return const Center(
                        child: Text('Search',style: TextStyle(color: Colors.white,fontSize: 40),),
                      );
                      case 2: _key.currentState?.closeDrawer();
                      return const Center(
                        child: Text('Settings',style: TextStyle(color: Colors.white,fontSize: 40),),
                      );
                      case 3: _key.currentState?.closeDrawer();
                      return const Center(
                        child: Text('Theme',style: TextStyle(color: Colors.white,fontSize: 40),),
                      );
                      default:
                        return const Center(
                          child: Text('Home',style: TextStyle(color: Colors.white,fontSize: 40),),
                        );
                    }
                  },
                ),))
              ],
            )
          );
        }
      ),
    );
  }
}

class SideBarXExample extends StatelessWidget {
  const SideBarXExample({Key? key, required SidebarXController controller}) : _controller = controller,super(key: key);
  final SidebarXController _controller;
  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme:  const SidebarXTheme(
        decoration: BoxDecoration(
            color: canvasColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20))
        ),
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        selectedTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
      ),
      extendedTheme: const SidebarXTheme(
          width: 200
      ),

      footerDivider: Divider(color:  Colors.white.withOpacity(0.8), height: 1),
      headerBuilder: (context,extended){
        return const  SizedBox(
          height: 100,
          child: Image(
          image: AssetImage("assets/images/shopwise_logo.png")),
        );
      },

      items: const [
        SidebarXItem(icon: Icons.home, label: 'Home',),
        SidebarXItem(icon: Icons.search, label: 'Search'),
        SidebarXItem(icon: Icons.settings, label: 'Setting'),
        SidebarXItem(icon: Icons.dark_mode, label: 'Light/Dark Mode'),
      ],
    );
  }
}


const primaryColor = Color.fromARGB(255, 196, 218, 200);
const canvasColor = Color.fromARGB(255, 44, 122, 59);
// Color.fromARGB(255, 57, 124, 68);
const scaffoldBackgroundColor = Color.fromARGB(255, 220, 240, 223);
