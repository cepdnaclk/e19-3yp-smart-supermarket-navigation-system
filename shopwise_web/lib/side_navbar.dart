import 'package:flutter/material.dart';
import 'package:shopwise_web/pages/dashboard/dashboard.dart';
import 'package:shopwise_web/pages/login/login.dart';
import 'package:shopwise_web/pages/product_placement/product_placement.dart';
import 'package:shopwise_web/pages/product_types/products_home.dart';
import 'package:sidebarx/sidebarx.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 1200;
        return Scaffold(
            backgroundColor: primaryColor,
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: canvasColor,
                    title: const Text(
                      'Shop Wise',
                      style: TextStyle(
                          color: scaffoldBackgroundColor, fontSize: 20),
                    ),
                    leading: IconButton(
                      onPressed: () {
                        _key.currentState?.openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: scaffoldBackgroundColor,
                      ),
                    ),
                  )
                : null,
            drawer: SideBarXExample(
              controller: _controller,
            ),
            body: Row(
              children: [
                if (!isSmallScreen) SideBarXExample(controller: _controller),
                Expanded(
                    child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context,child) {
                      switch (_controller.selectedIndex) {
                        case 0:
                          _key.currentState?.closeDrawer();
                          return const Dashboard();
                        case 1:
                          _key.currentState?.closeDrawer();
                          return const ProductsHome();
                        case 2:
                          _key.currentState?.closeDrawer();
                          return const Placement();
                        case 3:
                          _key.currentState?.closeDrawer();
                          //log out
                          return const LoginPage();
                        default:
                          return const Dashboard();
                      }
                    },
                  ),
                ))
              ],
            ));
      }),
    );
  }
}

class SideBarXExample extends StatelessWidget {
  const SideBarXExample({super.key, required SidebarXController controller})
      : _controller = controller;
  final SidebarXController _controller;
  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
          decoration: const BoxDecoration(
            color: canvasColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          iconTheme:
              IconThemeData(color: scaffoldBackgroundColor.withOpacity(0.6)),
          textStyle: TextStyle(color: scaffoldBackgroundColor.withOpacity(0.6)),
          selectedIconTheme: const IconThemeData(color: Colors.white),
          selectedTextStyle: const TextStyle(color: Colors.white)),
      extendedTheme: const SidebarXTheme(width: 200),
      footerDivider: Divider(color: Colors.white.withOpacity(0.8), height: 1),
      headerBuilder: (context, extended) {
        return const SizedBox(
          height: 100,
          child: Image(image: AssetImage("assets/images/shopwise_logo.png")),
        );
      },
      items: const [
        SidebarXItem(
          icon: Icons.dashboard_outlined,
          label: 'Dashboard',
        ),
        SidebarXItem(icon: Icons.shopping_bag_outlined, label: 'Products'),
        SidebarXItem(icon: Icons.shopping_cart, label: 'Layout Update'),
        SidebarXItem(icon: Icons.logout, label: 'Sign Out'),
        //SidebarXItem(icon: Icons.settings, label: 'Settings'),
      ],
    );
  }
}

const primaryColor = Color.fromARGB(255, 233, 247, 235);
const canvasColor = Color.fromARGB(255, 31, 91, 42);
const scaffoldBackgroundColor = Color.fromARGB(255, 220, 240, 223);
