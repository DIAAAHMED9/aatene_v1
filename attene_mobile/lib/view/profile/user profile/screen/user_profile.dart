import 'package:flutter/material.dart';

class ProfileSliverPage extends StatelessWidget {
  const ProfileSliverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [_buildSliverAppBar(context), _buildBody()],
      ),
    );
  }

  // --------------------------------------------------
  // SliverAppBar (الصورة الكبيرة + المصغرة)
  // --------------------------------------------------
  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: _circleIcon(Icons.more_horiz),
      actions: [
        _circleIcon(Icons.favorite_border),
        const SizedBox(width: 8),
        _circleAvatar(),
        const SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: _buildCoverImage(),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: _collapsedTitle(),
      ),
    );
  }

  // --------------------------------------------------
  // صورة الخلفية (Cover)
  // --------------------------------------------------
  Widget _buildCoverImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/cover.jpg', // ضع صورة مشابهة للصورة
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
            ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // العنوان عند Collapse
  // --------------------------------------------------
  Widget _collapsedTitle() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 14,
          backgroundImage: AssetImage('assets/images/avatar.jpg'),
        ),
        const SizedBox(width: 8),
        const Text(
          'Cody Fisher',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // أيقونة دائرية
  // --------------------------------------------------
  Widget _circleIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.9),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  // --------------------------------------------------
  // صورة البروفايل أعلى اليمين
  // --------------------------------------------------
  Widget _circleAvatar() {
    return const CircleAvatar(
      backgroundImage: AssetImage('assets/images/avatar.jpg'),
    );
  }

  // --------------------------------------------------
  // جسم الصفحة
  // --------------------------------------------------
  SliverToBoxAdapter _buildBody() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          const SizedBox(height: 16),
          _profileCard(),
          const SizedBox(height: 16),
          _tabs(),
          const SizedBox(height: 16),
          _bioSection(),
          const SizedBox(height: 40),
          _bioSection(),
          _bioSection(),
          const SizedBox(height: 40),
          _bioSection(),
          _bioSection(),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // كرت البيانات
  // --------------------------------------------------
  Widget _profileCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          children: [
            const Text(
              'Cody Fisher',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'username1128 • فلسطين - الخليل',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _followButton(),
            const SizedBox(height: 16),
            _statsRow(),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // زر المتابعة
  // --------------------------------------------------
  Widget _followButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('متابعة'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF476A8A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // الإحصائيات
  // --------------------------------------------------
  Widget _statsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _StatItem(title: 'تقييم', value: '4.5'),
        _StatItem(title: 'المفضلة', value: '30K'),
        _StatItem(title: 'متابع', value: '350K'),
      ],
    );
  }

  // --------------------------------------------------
  // التابات
  // --------------------------------------------------
  Widget _tabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: _cardDecoration(),
        child: Row(
          children: const [
            _TabItem(title: 'نظرة عامة', isActive: true),
            _TabItem(title: 'تقييمات'),
            _TabItem(title: 'المفضلة'),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Bio
  // --------------------------------------------------
  Widget _bioSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bio', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              'A paragraph is a unit of text that consists of a group of sentences related to a central topic or idea... المزيد',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // Decoration موحد
  // --------------------------------------------------
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
      ],
    );
  }
}

// --------------------------------------------------
// Widgets صغيرة قابلة لإعادة الاستخدام
// --------------------------------------------------
class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;

  const _TabItem({required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
