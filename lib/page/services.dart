import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Data layanan yang tersedia
  final List<ServiceCategory> serviceCategories = [
    ServiceCategory(
      title: 'Telekomunikasi',
      icon: Icons.phone_android,
      color: Colors.indigo,
      services: [
        Service(
          'Pulsa',
          Icons.phone_android,
          Colors.indigo,
          'Isi ulang pulsa semua operator',
        ),
        Service(
          'Paket Data',
          Icons.wifi,
          Colors.blue,
          'Paket internet semua operator',
        ),
        Service('Telepon', Icons.phone, Colors.green, 'Pulsa telepon'),
        Service('SMS', Icons.sms, Colors.orange, 'Paket SMS'),
      ],
    ),
    ServiceCategory(
      title: 'Utilitas',
      icon: Icons.bolt,
      color: Colors.orange,
      services: [
        Service(
          'PLN Prabayar',
          Icons.bolt,
          Colors.orange,
          'Token listrik prabayar',
        ),
        Service(
          'PLN Pascabayar',
          Icons.electric_bolt,
          Colors.red,
          'Tagihan listrik bulanan',
        ),
        Service('PDAM', Icons.water_drop, Colors.blue, 'Tagihan air'),
        Service(
          'Gas PGN',
          Icons.local_gas_station,
          Colors.purple,
          'Tagihan gas',
        ),
      ],
    ),
    ServiceCategory(
      title: 'Hiburan',
      icon: Icons.tv,
      color: Colors.purple,
      services: [
        Service('TV Kabel', Icons.tv, Colors.purple, 'Tagihan TV berlangganan'),
        Service(
          'Internet',
          Icons.wifi_outlined,
          Colors.cyan,
          'Tagihan internet',
        ),
        Service(
          'Streaming',
          Icons.play_circle,
          Colors.red,
          'Langganan platform streaming',
        ),
        Service('Gaming', Icons.games, Colors.green, 'Top up game online'),
      ],
    ),
    ServiceCategory(
      title: 'Kesehatan & Asuransi',
      icon: Icons.health_and_safety,
      color: Colors.green,
      services: [
        Service(
          'BPJS Kesehatan',
          Icons.health_and_safety,
          Colors.green,
          'Iuran BPJS Kesehatan',
        ),
        Service(
          'BPJS Ketenagakerjaan',
          Icons.work,
          Colors.blue,
          'Iuran BPJS Ketenagakerjaan',
        ),
        Service('Asuransi', Icons.security, Colors.indigo, 'Premi asuransi'),
        Service(
          'Rumah Sakit',
          Icons.local_hospital,
          Colors.red,
          'Pembayaran RS',
        ),
      ],
    ),
    ServiceCategory(
      title: 'Transportasi',
      icon: Icons.directions_car,
      color: Colors.teal,
      services: [
        Service('Tol', Icons.toll, Colors.blue, 'Top up kartu tol'),
        Service(
          'Parkir',
          Icons.local_parking,
          Colors.orange,
          'Pembayaran parkir',
        ),
        Service(
          'Bensin',
          Icons.local_gas_station,
          Colors.red,
          'Pembayaran BBM',
        ),
        Service(
          'Taksi Online',
          Icons.local_taxi,
          Colors.green,
          'Top up aplikasi transportasi',
        ),
      ],
    ),
    ServiceCategory(
      title: 'Pendidikan',
      icon: Icons.school,
      color: Colors.indigo,
      services: [
        Service('SPP', Icons.school, Colors.indigo, 'Pembayaran SPP'),
        Service(
          'Kursus Online',
          Icons.computer,
          Colors.blue,
          'Langganan kursus',
        ),
        Service(
          'Buku Digital',
          Icons.menu_book,
          Colors.orange,
          'Pembelian e-book',
        ),
        Service('Ujian Online', Icons.quiz, Colors.green, 'Biaya ujian online'),
      ],
    ),
    ServiceCategory(
      title: 'E-Commerce & Voucher',
      icon: Icons.card_giftcard,
      color: Colors.red,
      services: [
        Service(
          'Voucher Game',
          Icons.videogame_asset,
          Colors.purple,
          'Voucher top up game',
        ),
        Service(
          'Voucher Belanja',
          Icons.shopping_bag,
          Colors.red,
          'Voucher marketplace',
        ),
        Service(
          'Gift Card',
          Icons.card_giftcard,
          Colors.pink,
          'Gift card digital',
        ),
        Service('Cashback', Icons.money, Colors.green, 'Program cashback'),
      ],
    ),
    ServiceCategory(
      title: 'Pinjaman & Investasi',
      icon: Icons.local_atm,
      color: Colors.teal,
      services: [
        Service(
          'Pinjaman Online',
          Icons.local_atm,
          Colors.teal,
          'Ajukan pinjaman online',
        ),
        Service('Cicilan', Icons.payment, Colors.blue, 'Pembayaran cicilan'),
        Service(
          'Investasi',
          Icons.trending_up,
          Colors.green,
          'Platform investasi',
        ),
        Service('Deposito', Icons.savings, Colors.orange, 'Deposito berjangka'),
      ],
    ),
  ];

  List<ServiceCategory> get filteredCategories {
    if (searchQuery.isEmpty) {
      return serviceCategories;
    }

    return serviceCategories
        .map((category) {
          final filteredServices =
              category.services
                  .where(
                    (service) =>
                        service.name.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        ) ||
                        service.description.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        ),
                  )
                  .toList();

          if (filteredServices.isNotEmpty ||
              category.title.toLowerCase().contains(
                searchQuery.toLowerCase(),
              )) {
            return ServiceCategory(
              title: category.title,
              icon: category.icon,
              color: category.color,
              services:
                  filteredServices.isNotEmpty
                      ? filteredServices
                      : category.services,
            );
          }
          return null;
        })
        .where((category) => category != null)
        .cast<ServiceCategory>()
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Semua Layanan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 101, 106, 252),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Focus pada search field
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child:
                filteredCategories.isEmpty
                    ? _buildNoResultsFound()
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        return _buildServiceCategory(filteredCategories[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari layanan...',
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon:
              searchQuery.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[600]),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        searchQuery = '';
                      });
                    },
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Tidak ada layanan ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba kata kunci lain',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCategory(ServiceCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header kategori
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(category.icon, color: category.color, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  category.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: category.color,
                  ),
                ),
                const Spacer(),
                Text(
                  '${category.services.length} layanan',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          // Grid layanan
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: category.services.length,
              itemBuilder: (context, index) {
                return _buildServiceItem(category.services[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(Service service) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          _showServiceDialog(service);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: service.color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: service.color.withOpacity(0.2), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: service.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(service.icon, color: service.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        service.description,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showServiceDialog(Service service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: service.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(service.icon, color: service.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Layanan ini akan segera tersedia. Terima kasih atas kesabaran Anda.',
                        style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Tutup',
                style: TextStyle(
                  color: service.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Notifikasi untuk layanan ${service.name} akan dikirim',
                    ),
                    backgroundColor: service.color,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: service.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Beri Tahu Saya'),
            ),
          ],
        );
      },
    );
  }
}

// Model classes
class ServiceCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<Service> services;

  ServiceCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.services,
  });
}

class Service {
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  Service(this.name, this.icon, this.color, this.description);
}
