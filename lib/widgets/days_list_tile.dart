import 'package:always_victory/data/app_config/app_config.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/day_model.dart';

class DaysListTile extends StatelessWidget {
  const DaysListTile({
    super.key,
    required this.day,
    required this.index,
  });

  final DayModel day;
  final int index;

  @override
  Widget build(BuildContext context) {
    print( "${AppConfig.imageBaseUrl}${day.thumbnail}");
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: day.thumbnail.isNotEmpty
                    ? Image.network(
                  "${AppConfig.imageBaseUrl}${day.thumbnail}",
                  height: 70,
                  width: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print("IMAGE ERROR => $error");

                    return Container(
                      height: 70,
                      width: 90,
                      color: Colors.red.shade100,
                      child: const Icon(Icons.broken_image),
                    );
                  },
                )
                    : Container(
                  height: 70,
                  width: 90,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image),
                ),
              ),

            ],
          ),

          const SizedBox(width: 12),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP ROW
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        day.dayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),


                  ],
                ),

                const SizedBox(height: 8),

                /// TITLE
                Text(
                  day.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                /// DESCRIPTION
                Text(
                  day.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          /// ARROW
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}