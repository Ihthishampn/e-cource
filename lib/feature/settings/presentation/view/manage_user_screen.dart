import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ManageUserScreen extends StatelessWidget {
  const ManageUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Manage Users",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),
          const SizedBox(height: 20),
          
          // Search Bar & Filter Button
            Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(8),
                  ),
                    child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search..',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  ),
              ),
              const SizedBox(width: 16),
              Container(  height: 48,    decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.tune, color: Colors.white, size: 18),
                  label: const Text(
                    'All',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
                
             ) ],
            ),  
            
            const SizedBox(height: 24),
            
            // Lt of Users
            Expanded(
            child: Builder(
              builder: (context) {
                final dummyData = [
                    {
                    'initial': 'A',
                    'id': 'o7maxCWcz3PeZUnqGrXD32lKeTu1',
                      'name': 'amal dev',
                    'phone': '+918590941583',
                    'course': 'No Course',
                    'date': 'N/A'
                  },
                  {
                    'initial': 'A',
                    'id': 'KwH8mtR0CdYCFmZiAljDGFa02WN2',
                    'name': 'ameer musthafa',
                    'phone': '+919995576333',
                    'course': 'No Course',
                    'date': 'N/A'
                  },
                  {
                    'initial': 'H',
                    'id': 'wVP3pFAAR6NMwodXaedtl8QUal23',
                    'name': 'Hima K Manoj',
                    'phone': '+917907087819',
                    'course': 'No Course',
                    'date': 'N/A'
                  },
                  {
                    'initial': 'R',
                    'id': 'ip3LqL9XozNaSPCslmg643bcWWD3',
                    'name': 'Rahul K P',
                      'phone': '+917994408211',
                      'course': 'No Course',
                      'date': 'N/A'
                    },
                  ];
                  
                  return ListView.separated(
                    scrollCacheExtent: ScrollCacheExtent.pixels(2000), itemCount: 15, 
                    physics: const ClampingScrollPhysics(), // Keeps items in memory to prevent lag
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final user = dummyData[index % dummyData.length];
                      
                      return RepaintBoundary( 
                        child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              user['initial']!,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow('ID', user['id']!),
                              const SizedBox(height: 8),
                              _buildInfoRow('User Name', user['name']!),
                              const SizedBox(height: 8),
                              _buildInfoRow('Phone Number', user['phone']!),
                              const SizedBox(height: 8),
                              _buildInfoRow('Course Name', user['course']!),
                              const SizedBox(height: 8),
                              _buildInfoRow('Purchase Date', user['date']!),
                            ],
                          ),
                        ),
                        
                        // Toggle Switch
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Enabled',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: true,
                                onChanged: (val) {},
                                activeThumbColor: Colors.white,
                                activeTrackColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(
          ': ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}