Package.define('craftd') {
  tags 'application', 'game', 'sandbox', 'minecraft', 'server'

  description 'craftd is a third-party implementation of the Minecraft SMP server protocol.'
  homepage    'http://mc.kev009.com/Craftd:Main_Page'
  license     'BSD'

  features {
    self.set('ignore-version') {
      before :configure do
        Do.cd('src/network') {
          package.patch filesystem.files.ignore_version_patch if enabled?
        }
      end
    }
  }

  before :install do
    package.do.into('/usr/share/craftd/htdocs') {
      package.do.ins(*%w(js css images *.html).map {|file| "htdocs/#{file}"})
    }
  end
}

__END__
$$$

$$$ patches/htdocs/Makefile.am.patch $$$

--- Makefile.am.orig	2011-02-18 16:33:01.304170506 +0100
+++ Makefile.am	2011-02-18 18:58:52.400433507 +0100
@@ -4,14 +4,4 @@
 dist_noinst_DATA += logs.html help.html players_blacklist.html players.html
 
 install-data-hook:
-	if ! test -d $(htdocsdir); then \
-		$(mkdir_p) $(htdocsdir); \
-		for p in $(dist_noinst_DATA); do \
-			if test -f "$$p"; then d=; else d="$(srcdir)/"; fi; \
-			echo "$$d$$p"; \
-		done | $(am__base_list) | \
-		while read files; do \
-			echo " $(INSTALL_DATA) $$files '$(htdocsdir)'"; \
-			$(INSTALL_DATA) $$files "$(htdocsdir)" || exit $$?; \
-		done \
-	fi
+	$(mkdir_p) $(DESTDIR)$(htdocsdir)

$$$ files/ignore_version_patch $$$

--- process-game.c.orig	2011-02-18 16:03:28.928801506 +0100
+++ process-game.c	2011-02-18 16:03:40.621952007 +0100
@@ -145,7 +145,7 @@
   // TODO: Future, check against local ACL
   
   /* Check if the client version is compatible with the craftd version */
-  if (ver != PROTOCOL_VERSION)
+/*  if (ver != PROTOCOL_VERSION)
   {
     bstring dconmsg;
     dconmsg = bfromcstr("Client version is incompatible with this server.");
@@ -153,7 +153,7 @@
     bstrFree(dconmsg);
     return;
   }
-  
+  */
   /* Otherwise, finish populating their Player List entry */
   pthread_rwlock_wrlock(&player->rwlock);
   player->username = bstrcpy(username);

--- process-proxy.c.orig	2011-02-18 16:04:42.348073510 +0100
+++ process-proxy.c	2011-02-18 16:04:54.015237010 +0100
@@ -57,7 +57,7 @@
 	struct packet_login* lpacket = (struct packet_login*) packet;	
 	
 	/* Check if the client version is compatible with the craftd version */
-	if (lpacket->version != PROTOCOL_VERSION)
+/*	if (lpacket->version != PROTOCOL_VERSION)
 	{
 	  bstring dconmsg;
 	  dconmsg = bfromcstr("Client version is incompatible with this server.");
@@ -65,7 +65,7 @@
 	  bstrFree(dconmsg);
 	  return;
 	}
-	
+*/	
 	/* Otherwise, finish populating their Player List entry */
 	pthread_rwlock_wrlock(&player->rwlock);
 	player->username = bstrcpy(lpacket->username);	
