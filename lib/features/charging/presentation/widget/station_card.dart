import 'package:flutter/material.dart';
import 'package:tripplus/features/charging/domain/models/charging_station.dart';

class StationCard extends StatelessWidget {
  final ChargingStation station;

  const StationCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 10),
            if (station.address != null)
              _InfoRow(
                icon: Icons.location_on_outlined,
                text: station.address!,
              ),
            if (station.town != null)
              _InfoRow(
                icon: Icons.location_city_outlined,
                text: [
                  station.town,
                  station.stateOrProvince,
                  station.country,
                ].where((e) => e != null).join(', '),
              ),
            if (station.operatorName != null)
              _InfoRow(
                icon: Icons.business_outlined,
                text: station.operatorName!,
              ),
            if (station.usageCost != null)
              _InfoRow(
                icon: Icons.payments_outlined,
                text: station.usageCost!,
              ),
            const SizedBox(height: 8),
            _buildStatusRow(theme),
            if (station.connections.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildConnectionsSection(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.ev_station,
          color: theme.colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            station.name,
            style: theme.textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (station.distanceKm != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${station.distanceKm!.toStringAsFixed(1)} km',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusRow(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        if (station.statusType != null)
          _Chip(
            label: station.statusType!,
            isPrimary: true,
            isPositive: station.isOperational ?? false,
          ),
        if (station.numberOfPoints != null)
          _Chip(label: '${station.numberOfPoints} point(s)'),
        if (station.usageType != null)
          _Chip(label: station.usageType!),
      ],
    );
  }

  Widget _buildConnectionsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connectors',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        ...station.connections.map((c) => _ConnectionRow(connection: c)),
      ],
    );
  }
}

class _ConnectionRow extends StatelessWidget {
  final Connection connection;

  const _ConnectionRow({required this.connection});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = <String>[
      if (connection.connectionType != null) connection.connectionType!,
      if (connection.powerKw != null) '${connection.powerKw} kW',
      if (connection.currentType != null) connection.currentType!,
      if (connection.quantity != null) 'x${connection.quantity}',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            connection.isFastCharge == true
                ? Icons.flash_on
                : Icons.power_outlined,
            size: 14,
            color: connection.isFastCharge == true
                ? Colors.orange
                : Colors.black38,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              parts.join(' · '),
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black38),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final bool isPositive;

  const _Chip({
    required this.label,
    this.isPrimary = false,
    this.isPositive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color bgColor;
    final Color textColor;

    if (isPrimary && isPositive) {
      bgColor = theme.colorScheme.primary.withValues(alpha: 0.1);
      textColor = theme.colorScheme.primary;
    } else if (isPrimary) {
      bgColor = Colors.orange.withValues(alpha: 0.1);
      textColor = Colors.orange.shade800;
    } else {
      bgColor = Colors.grey.shade100;
      textColor = Colors.black54;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
