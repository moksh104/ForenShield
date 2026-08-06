/// ForenShield Widget Catalog — Inputs section.
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/components/foren_components.dart';
import 'catalog_helpers.dart';

class InputsSection extends StatelessWidget {
  const InputsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogSection(
      title: 'Inputs',
      description: 'Search Bar, Filter Chip, Dropdown, TextField.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CatalogSubsection(
            label: 'Search Bar',
            child: SizedBox(
              width: 360,
              child: ForenSearchBar(hint: 'Search cases, evidence, courses...'),
            ),
          ),
          const CatalogSubsection(
            label: 'Filter Chip (toggleable)',
            child: _FilterChipPreview(),
          ),
          const CatalogSubsection(
            label: 'TextField',
            child: SizedBox(
              width: 360,
              child: Column(
                children: [
                  ForenTextField(label: 'Case Title', hint: 'Enter case title'),
                  SizedBox(height: ForenSpace.md),
                  ForenTextField(
                    label: 'Password',
                    hint: 'Enter password',
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  SizedBox(height: ForenSpace.md),
                  ForenTextField(
                    label: 'IP Address',
                    hint: '192.168.1.1',
                    errorText: 'Invalid IP format',
                    prefixIcon: Icons.public,
                  ),
                ],
              ),
            ),
          ),
          const CatalogSubsection(
            label: 'Dropdown',
            child: SizedBox(width: 360, child: _DropdownPreview()),
          ),
        ],
      ),
    );
  }
}

class _FilterChipPreview extends StatefulWidget {
  const _FilterChipPreview();

  @override
  State<_FilterChipPreview> createState() => _FilterChipPreviewState();
}

class _FilterChipPreviewState extends State<_FilterChipPreview> {
  final _selected = {
    'Critical': true,
    'High': false,
    'This week': false,
    'Active': true,
  };

  @override
  Widget build(BuildContext context) {
    return CatalogPropRow(
      children: [
        for (final e in _selected.entries)
          ForenFilterChip(
            label: e.key,
            selected: e.value,
            feature: ForenFeature.investigation,
            onSelected: (v) => setState(() => _selected[e.key] = v),
          ),
      ],
    );
  }
}

class _DropdownPreview extends StatefulWidget {
  const _DropdownPreview();

  @override
  State<_DropdownPreview> createState() => _DropdownPreviewState();
}

class _DropdownPreviewState extends State<_DropdownPreview> {
  final _options = [
    'Email Phishing',
    'Malware Analysis',
    'Network Intrusion',
    'Data Exfiltration',
  ];
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return ForenDropdown<String>(
      label: 'Case Category',
      value: _selected,
      items: _options,
      itemLabel: (s) => s,
      onChanged: (v) => setState(() => _selected = v),
    );
  }
}
