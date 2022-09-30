PGDMP     .                    y           NYCountyAidCrime    13.1    13.1     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    17443    NYCountyAidCrime    DATABASE     v   CREATE DATABASE "NYCountyAidCrime" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1252';
 "   DROP DATABASE "NYCountyAidCrime";
                postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   postgres    false    3            �            1255    17585    update_aidamount()    FUNCTION     �  CREATE FUNCTION public.update_aidamount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
  UPDATE NYAidCrimeMean
  set AidAmount_mean = sub_q.newaidmean, Aidpercap = sub_q.newaidmean / sub_q.newpopmean
  from (select avg(new.aidAmount) as newaidmean, avg(new.population) as newpopmean from NYAidCrimeTimeSeries where county = old.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$$;
 )   DROP FUNCTION public.update_aidamount();
       public          postgres    false    3            �            1255    17635    update_aidamountmean()    FUNCTION     �  CREATE FUNCTION public.update_aidamountmean() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
  UPDATE NYAidCrimeMean
  set AidAmount_mean = sub_q.newaidmean, Aidpercap = sub_q.newaidmean / sub_q.newpopmean
  from (select avg(new.aidAmount) as newaidmean, avg(new.population) as newpopmean from NYAidCrimeTimeSeries where county = old.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$$;
 -   DROP FUNCTION public.update_aidamountmean();
       public          postgres    false    3            �            1255    17591    update_capaidamount()    FUNCTION     v  CREATE FUNCTION public.update_capaidamount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
  UPDATE NYAidCrimeMean
  set Aidpercap = sub_q.newaidmean / sub_q.newpopmean
  from (select avg(aidAmount) as newaidmean, avg(population) as newpopmean from NYAidCrimeTimeSeries where county = old.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$$;
 ,   DROP FUNCTION public.update_capaidamount();
       public          postgres    false    3            �            1255    17600    update_crimesmean()    FUNCTION     �  CREATE FUNCTION public.update_crimesmean() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
  UPDATE NYAidCrimeMean
  set CrimesReported_mean = sub_q.newcrimesmean, crimesPerCap = sub_q.newcrimesmean / sub_q.newpopmean
  from (select avg(new.crimesReported) as newcrimesmean, avg(new.population) as newpopmean from NYaidcrimeTimeSeries where county = new.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$$;
 *   DROP FUNCTION public.update_crimesmean();
       public          postgres    false    3            �            1255    17603    update_jailmean()    FUNCTION     U  CREATE FUNCTION public.update_jailmean() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
  UPDATE NYAidCrimeMean
  set JailPopulation_mean = sub_q.newJailmean
  from (select avg(new.JailPopulation) as newJailmean from NYAidcrimeTimeSeries where county = new.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$$;
 (   DROP FUNCTION public.update_jailmean();
       public          postgres    false    3            �            1255    17597    update_populationmean()    FUNCTION       CREATE FUNCTION public.update_populationmean() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
  UPDATE NYAidCrimeMean
  set Population_mean = sub_q.newpopmean, Aidpercap = sub_q.newaidmean / sub_q.newpopmean, CrimesPerCap = sub_q.newcrimemean / sub_q.newpopmean
  from (select avg(new.aidAmount) as newaidmean, avg(new.population) as newpopmean, avg(new.CrimesReported) as newcrimemean from NYAidCrimeTimeSeries where county = new.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$$;
 .   DROP FUNCTION public.update_populationmean();
       public          postgres    false    3            �            1259    17637    nyaidcrimemean    TABLE       CREATE TABLE public.nyaidcrimemean (
    county character varying(50) NOT NULL,
    aidamount_mean integer,
    population_mean integer,
    jailpopulation_mean integer,
    crimesreported_mean integer,
    aidpercap integer,
    crimespercap double precision
);
 "   DROP TABLE public.nyaidcrimemean;
       public         heap    postgres    false    3            �           0    0    TABLE nyaidcrimemean    ACL     �   REVOKE ALL ON TABLE public.nyaidcrimemean FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE ON TABLE public.nyaidcrimemean TO postgres;
          public          postgres    false    200            �            1259    17642    nyaidcrimetimeseries    TABLE     �   CREATE TABLE public.nyaidcrimetimeseries (
    county character varying(50) NOT NULL,
    year integer NOT NULL,
    aidamount integer,
    population integer,
    jailpopulation integer,
    crimesreported integer
);
 (   DROP TABLE public.nyaidcrimetimeseries;
       public         heap    postgres    false    3            �          0    17637    nyaidcrimemean 
   TABLE DATA           �   COPY public.nyaidcrimemean (county, aidamount_mean, population_mean, jailpopulation_mean, crimesreported_mean, aidpercap, crimespercap) FROM stdin;
    public          postgres    false    200            �          0    17642    nyaidcrimetimeseries 
   TABLE DATA           s   COPY public.nyaidcrimetimeseries (county, year, aidamount, population, jailpopulation, crimesreported) FROM stdin;
    public          postgres    false    201            +           2606    17641 "   nyaidcrimemean nyaidcrimemean_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.nyaidcrimemean
    ADD CONSTRAINT nyaidcrimemean_pkey PRIMARY KEY (county);
 L   ALTER TABLE ONLY public.nyaidcrimemean DROP CONSTRAINT nyaidcrimemean_pkey;
       public            postgres    false    200            -           2606    17646 .   nyaidcrimetimeseries nyaidcrimetimeseries_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.nyaidcrimetimeseries
    ADD CONSTRAINT nyaidcrimetimeseries_pkey PRIMARY KEY (county, year);
 X   ALTER TABLE ONLY public.nyaidcrimetimeseries DROP CONSTRAINT nyaidcrimetimeseries_pkey;
       public            postgres    false    201    201            /           2620    17652 6   nyaidcrimetimeseries update_aidamountmean_after_update    TRIGGER     �   CREATE TRIGGER update_aidamountmean_after_update AFTER UPDATE ON public.nyaidcrimetimeseries FOR EACH ROW EXECUTE FUNCTION public.update_aidamount();
 O   DROP TRIGGER update_aidamountmean_after_update ON public.nyaidcrimetimeseries;
       public          postgres    false    202    201            0           2620    17653 3   nyaidcrimetimeseries update_crimesmean_after_update    TRIGGER     �   CREATE TRIGGER update_crimesmean_after_update AFTER UPDATE ON public.nyaidcrimetimeseries FOR EACH ROW EXECUTE FUNCTION public.update_crimesmean();
 L   DROP TRIGGER update_crimesmean_after_update ON public.nyaidcrimetimeseries;
       public          postgres    false    201    216            1           2620    17654 1   nyaidcrimetimeseries update_jailmean_after_update    TRIGGER     �   CREATE TRIGGER update_jailmean_after_update AFTER UPDATE ON public.nyaidcrimetimeseries FOR EACH ROW EXECUTE FUNCTION public.update_jailmean();
 J   DROP TRIGGER update_jailmean_after_update ON public.nyaidcrimetimeseries;
       public          postgres    false    217    201            2           2620    17655 7   nyaidcrimetimeseries update_populationmean_after_update    TRIGGER     �   CREATE TRIGGER update_populationmean_after_update AFTER UPDATE ON public.nyaidcrimetimeseries FOR EACH ROW EXECUTE FUNCTION public.update_populationmean();
 P   DROP TRIGGER update_populationmean_after_update ON public.nyaidcrimetimeseries;
       public          postgres    false    218    201            .           2606    17647 5   nyaidcrimetimeseries nyaidcrimetimeseries_county_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.nyaidcrimetimeseries
    ADD CONSTRAINT nyaidcrimetimeseries_county_fkey FOREIGN KEY (county) REFERENCES public.nyaidcrimemean(county);
 _   ALTER TABLE ONLY public.nyaidcrimetimeseries DROP CONSTRAINT nyaidcrimetimeseries_county_fkey;
       public          postgres    false    2859    200    201            �   L  x�E�ێ7����	t"%^f�d�$^�YrS��ۍ����3o��*�9M�����|X��P4�5i�o��r�]rCjH�$鹛H��YR���岞�6��-�ȡ�f��-��4�ڛ�-��NQ*f��ܮח5�Qj֒F�&g�,ECn-�[�(�5�p���,��r[���(��i	}.��!�ŵ{uU�ٴ�1R.c4�_�%��z>Ke�ѹ*5�\����F��?�k|�yyܗ��K(�s�k�J%�Z�g�T��Uh��!R����c;��М�k��
m�rC��fi>Ѕ�Jj��۲�����R�cm�`��sER�-�Z*93����ݯ�_Z��&a�ܨHBό-�ҖZ�R�<���zy�|8/A�qZ~�@�͡�h^���}T+=g>�C���eٞ�H��趁�W�&\�w�ЕIR�߭���r[�&��h���9�2zk�$�VL��=�?���Y`��@��Zh9FU��t�Sj�� �����t�f�A�e���� I|BuL&I3��HV�������t&�BN��L�lv�s��5���_���mٞ�燸9��O~�f�pŬE�h��&Ч�����P�@��5H�	���MgD��E4����ۺ��ߨ����*a�N���9S)i�(���r���av� �9R�}�<��@��-/��j� �R-��1D �,#��E������j�^ЇbD50�8��EW?(F�,���O�mw����`!RhE6�f��P���?�8_i.��~9�� S�Z��q4+ʕ�%w�^$�x�㼝�	��?m.��|��e�Q�`\�}�!���<��ک�Ich��@iTփ<�#P;05�?]���qT<g�'�&��ǐ-R\��@�t>�z/�����k��5$�ŀ�AR�|1Қc72�-��eߗ���a��v����y�cX�A��С���y9�װ�o�ς򃷚g�t}x=�Wk�����o���D-�<�3F�Ժ���A|/�qI�&������AQQ�@���˽ˆ��2%~]:w�n�T2g<�y��XJ4�7�:�� $4cRx"-�E�'t���DL{�1P�o��}����ss��B�e]�=�
<��5|)�/q��N��D�IU��_V�`� .N3'a�<����g��c'����w/5�ǜ����=J�!�z�܊[m��?����a�ŧbVQs��ѧڸ�bڨ���O����yY\�D`3s�b/<��zn/G��;�h�sa���\?>�d)Xf��	����;!�t9�-xga�ܤS�ޯ��m�M��hq�W�10&�f	5�#\���}yb��\�Se�T3TX�D6�����<��|Z��_?/4�/8�ޜI�����$�Ї�ăW>^/���.�ᶋZ���I^�	L�&?d��;ox��<8Y� ��|��$_9��G�e�Ϥ���>>����3�
�9�k������!560����>]/�|�N�����	��Ks�3�y1�3R��BB��r�c�܌0R��>�A|�S=�i_�2�VzW`X����qu�$G��O$I�k���00&�Bzj��^_��|Fi8]c�]H�������a.��+H²���~�셗�;�;�)|r�'��5ߨ���}N������l��AFy`���0�=0�_[r�4�n���3q3��t8+f�\v�;�J�Eu(_8��W"�m��ԡ*?�����}��h�����# ����>�*,-�!���h\|=��Μ�.ō�v������_�/t�m�b��C�|;s`������$�o�}�}3q��q|T�P��WH4g�
��{�������D      �      x�m�َ%ɕ]�o|��n�=�� ��B����`U��"����k��q�n���;�͏�a����>����o�t��-�<��s�G9F��9�ɘ���}��[J��9�SX����O�K�ZO�1��S���n�e��[��('� kuL`�v�y��� �܇�����N`��Vy��k/�	X��V���-����-��F�)V��c�V�\`���񦽟��\`�h���H�z�zc���s]��;Yo��G�vr�#�
�_~�8��(<-��V�tc�w�s�����&Y�8��\j�i�T9�2����;�}���Ysa[_O�yl�r;�#�s�����ɿki��3�,�W�9�_=7��bo�(�T���0d���
��VZC=O�~��E�[A�����]��F���閭Z��@��5�����~���˛�^��;:|�c(nu�u�ay��Q���nx���e�%5��ⱟs��鉹�a�V��W�vvDw�����x�9�X������0�`䂭��s�����X�a����+k�����h�YF�h�eԎW��t���O1����M �~����������L���
��u=����ߟ�>���Ƿ7C��q��H�0���G�����Φϡ�%v��xD"��jMHd.���T�����"�9���2RxD"��F�j����p1���}�{T���grM܇r|@z�Ȼ�gA6u+B��#R}���o��ja�	�xD�ˏ���[���xD�{������5|�N�3��?=������Ч/�k�=- �k�އ�1Q]_�+&�&����`����j�L��64hr�$_0�/�[e+�6�dU�,�����pL��4::��d��Y�������m��P0���SW�q��\A�W)DLΙ�1f	BY�^�D�y\�S� V��������ǛȉE�����?��ab�H��+4�a �($�<T�i�ƷuM} ��&��F����BƊ��ɳ'= �T!�����0��Q��@I(V�/|�����=>��4�B램-O������IU��s��#�8�ǧ�8k�C�1��F���Q��O�Ua|�!qi�92ȗ_���f�aX�e���˺�N�#fXٿ�:X�JqG%�&��Q`D(�䉠Uڊ�&�
��N���
z��"��J�N��|O�qEUw����<tӍ�m��tTE r6�6�w����0b�l���]&4��D��h�c2T�dXUv��x������p-O������/o�G�8 �:�
Q̈DiC�Aa4""1�q�ܾ�~*���0�@yG����
B�j*�b�|�e�)}(i�x ÂoS�~�3J8K	��C���6��
�B)x$���uC�P�T��jp�ocCI�&>����f����4v�<B+�����X����_^�dO��4��$!	�$�(e���e�c9|N[Q��y�8DEr��XQ�������I%U��
����*<�~G�G��9���;�v��H� J
���0j]Q���0'e,��y-(�@�f%tuO���l�P񋛟>���������?~�㧷�� ���;�Ԧ��;�U����q��/Y�<9-9S	�EȤ
�0�)�i̪�~l�rkGA6��U=�c	��.P�v�Eu��X�/ �ˌK����E`�g}�x��;��Y���x�N��?7C,��q�Jl���2�qO�������ϯ�$����,�V�R��7�����c`��X����!�`� �Y�xS�y��V�n3B������8h*:ɮ�}��Jg�@2��b�l����ba*d�EsA]����Y*����Ü�����9p�9���%��`H��V�(	������ח��}�����]rϑQ4oM����
�6�p%r�i@96
�����L,��?N��q�[1y��i8����{���K# #�2��!qN!ȑǵl?m N?'��N!ɡC-eA�0�.3M����7̐�X��
�K���t&����^�z�ԙ����O?�|{˾�� ���u��0���\�&�ć�4]7�(Q��in@Sad	Ý���_�5qo��U{�qlBΔL��'%W��nV3 4m=�Q��[��j�A�a����̇�j�t+��CFq�H�����x��%���v�ː)�gF7�ֻ?��(���c����Zp��J�_Dk>���맗� kR�Ĵ�tKh/����aQ�N48��"_��@���!�N��]��+��Y�:��$B6P��LU�+�A��W�&��Z B�	3�|�"+�Xx�p�����<f�EZ�o�ݽAD#I"S��8�3�n����*ӡ�Č��@���r��7-�%X�J'جl�}&�y3�!֓G���o/��:��(@mf��{T��!�e8���ֻ#�)2���3D���d��m��Zè'��c| ��6	��#��@ ��U$�(�֌��t47c@d��5�Z� ���u7�.u�7�@��
K���߳�ETS��
�c-�$����ϯ��p.q���i�Z�T�3ncEE�r�<o�j�Z�F�P��H��iHπu���ʜ�qT�R,( �_Q��Լ�#�(���kYI����0��ʥq�l0k	����j#��f�@Զ6�j�;�)G���F���D�:;����^�:#�9���*��Ï�t}BeQL�V����@L`�r�y�,��b�YL�t5���l}P֚�0���t�i�KD�GVF����_ �Zmxn!C�0��u���0}$��%���n�l�.bvo�BL�C����i�e�eqː%/�Yl�V, �����������˻��<O@D~sF��b��XS>6RѸCS��ۊ�3q��s�ͬ�b
/�`Tk���^��ŒG]1?-���ɉ�+m뼫���NE��$kH���z{5u��9�x�:C�d�;r<�
R���r�͜G�8Ǌ�bg��	p%�����7JJ����Tnv�@�qZ�K=�a_ PB�!�?����.)$�sD�M�gR��] 8�f�/}�]%��%Es`/R�&���c] ��������Ǳ�bT�`������,���Qz���Q
�@̽&�5��fٚ�|���_?��EF	[����d��ԧ�(���Hv[mE:mE�� �!�:$��K6�m��#s����J�Z�E���o?o�1��P-���+�G��X�ȷlc���a���㧰�]J<S�ѣ��p������O��|}�	�����f���}C���v���y������r�K�i[`VWm�m(3e|�'(���:I�QAà����!��$b�(n����$N��p���A���T�U��͹��O�)@2�% ���'�n�(Y��r]���8�B;���W#��Ը�����_�����G�j��,
�r������h[��"D���j=��c���Gs[��^bp���w�O��\�̇=�(Wr���B�ޯ���h�$:�)^&P�
l@#\�I+�(E׊d�;0��*)G��3�y�xx�՛3��:��#�8���CS� m�f��察޲L|e��I�;���w�i��Mg�ɲ��"�w{�m���<B�Al�QXfxt�d/R��g�A+(w��:�0ᴳ� &
Ѳ� �x��Q��� �& ҇��-���� ��G䱬�3���a^3�m���|z�����  ��WSP�#1p�EڣIKx�u>Kx��fE�c�vdeyS�1�M����Rt�;�\I$��B�z��@/�G ���GEl�_���3s��۳�D��d/��q=:��(y�\,�$�AK@iJ��aI5i�>�z뎳� =��i�o����~���9�(8�Q�4$�u<`S�X��yΊ��Y��hW򦖷kܲ�z�ê+�����%gA\(Hc-VI�p-���
R�[Fa�@ԣ`E�\AJ}�6�Ch�䶁��(T�Y���ܭ��/�#&]o+��فc=��ׯ_��$���4��;t����q�5�W\�7I���Iw�B�y+��B9~|,8�w3Y��{�TOU�-D����    t�a�ێX�^���uz Dt���{� o�h��� &���K��Ve)&�P{1�c����BE�!ۡ��/G���1$VG]�s.VV���(�4�gDaq��Bx~�gB��&0؃���q��="�oNð�5T�g������9�d�����"Fm�-0�:��j���tJ�B�8;1�1���ᔊ���r~U2�W��suJ�0���х$0�0�����c���^��L��u�P�6y�+%Ϳ����]�f�y��*���۷��a��6���u�z9�M8$� ����,ͱ��`��ԪI�))T/�\��W A��do�������ȁ����?d_ш��(L�/@N�9qT�Q[����z^ݮ��>f�Xg�
���>O��.��N3
x���2&;�<�I k -YC��`&���,I봿��z�����O�_�<�f��[m?��p��_��Ac��@-9���s�����ᢤ�%^q�+�7Y�gܢ�K�[p1�G��%.G����KL#��D�l�5���V\�d(��̤(�5y-W�����/LV,�F��_p����z�2�i1R�^��)��%l�o>�5O�{}�����@
�K����0�i��j�h`)��Z�����kk9��+��\G圣�ò��X9��U(��Ր���dxú�������mTX0#*5�;��{��[�S��v�t��r��$��#**1�B�|G���:�w"�ҭ�Wl�������}�(0�<��(��^�����}Ȍ4����`9W.��V$���ک5���|��r���H2�a��*q�4]-���HN����W�jE��8��ZG�}���N��ϴ���em-�jt9��~����;�J��ӱ�#:��W��1�2��}ַ5�hlHt�7�3[0��t� [؀VЊ���w�W:3��{�������,��ǂ*���9�<`�͑Z6��(L�`9j[aƫZY�"��S�!�+,v�j���=�����L1U</�uژ(+�~l=[���� ,m{�Ym��\ぎ��Ij�����4r�zݬJ�;�������9�6ǘzL��0K�,�-�
.h�����ϯ?�W?���jC'۸o���`���C��7�ab���	�;L����`Zy�n0U�X�*췘�U�g$�(��P�k�y����s�ۈ��^�;�����hq־��%���Cx=�fi�4u}h����i9�G��Ŝ4	��)�Dp5ݤ1 ��X��3j��@R��9���z:��/ϯo�F7���yMi�c�BO��E�Z�+F��Q>�r�o��q�a%KΎFe��b
I��,N8�s�m�س�i�uN����mϸ��=�*���)pLrŐ �u�
�5w�o�G�F���G��Qr�3�#c��ٵ�$����}�/)0"^������i�����9�L֍B(�ħ��:��5��<T̽�r���N�����J�x�>RT땡�*�弫$��R f_��"���b���|^s��-��rGEU�.��V6��IYZPθ�C�f�w��'�Zw�Kv�s���.��qb���o�7p�N ��ƞ���!fq/+(�wv5��C���p�űu��c�D�@nia'J�q=�Ķ����f�kv,��m�N�}�w�|��n��F$K�s��Oi�^���:�D�F�q��׽���3 ����*�^�U�2su��d����������x��â�3�W��[0z�5)�if�z���;�^���}N#��;�G��v�c"3*��{�w�} �>�H�,y\�����3VM������Q�!��xxVFw�2�f�Ux��{�`pٵŴ�����);$��l�/��f"���#�����/�߾�|~�h�L�4G_�b��8�v< Cf&��)��������ޕ�g c�q�j���J��њ��3�)���>��]I[�Z�J��>�iyΨ4��.�K+�qM���a �3��Á�R�W�oa����C��)��ܳ�i�nvC�ݑ$	��'�jzt����ӿ~��/��J��IƂ�D���%Ԙ��N�8��l����ߐ���y�,�:̰�lӐ�:H�U&眢�F��p%6��G�U�3�Q��?�F	����\����A��h@&���0��P�#yF����g/�� o��F���-�:���ʊ��l5��-ຣ�z0�
�'S���=���3I��Ϙ�@��b���V6R�?�sϱ�,�ì�(�W�|I�W\\�z��91=����Xqq�7��E5�~��V��M�l�f8iʊ�<�9��:Qڏ��������HE�q��a|�D�3�O�ҝr���%FW���푂C{���~~y}����?���^R�Ȉ�K�H���W���S�q�J�s<Q �~����
�6��˕��g~���l}U�SlFU� |�^W�$��c]���h��뎜��3R��?q�� �:t�i(�l]o1��`���L2�/!���Ō�odk���9��k��x����h=1��G���z��Q�~���czәkT��o���B�A��m�5���Y��=��`�>�I�����A�J;0y^̧y�W����bJL�X��d�Zſ�꬧�8�*v.,o;��'����Ft�p#V`7�fs%�Mhk���g����]�YOئ�r*:n}hKq:?���=�',�{;���ʆ1I �F��A����a�z܌Yi;�z,��F��e��.y$~�f��bJt�J�0����0�~cD!��Σ�{���^�f衹��a좓�����Q��o��9��:�F�{��0����Pb?�j�^x~��4��d��E�_ �Ñ(C�J,�^�c�q�ћ�gt�F��Ÿ����i�|��x��;$Fe��m�C�qs�.�jP�&�B���s�n>R�(	�&�5ݼ@�����u`tԞ��V������"$uZ�N��< �z��[\�����/+���+ޯ��+*FDbdY����VT܅E����ݤ�d[�w�u"2,���x�k��(�m���X�T�����W�{���<�{P9�+�1\�t7w�C5ˊ2b>��<��ͫl���"�z22�aN/�������F�^�~�G�~��/����� [-8;jQ,vjO�� �+4.��3z�B����q�O-P�+�غi$�6�`֜k��4�%eLH�s���k��;4F(�s9�U�t��a����)j�֩A��N��������S�`Eў4B�@9�C?<�V �!	%W��W�7��ʎ�yWf��p����8^��~�h���0{?��������<�Z �(�v�Y���}}������3�*cPǆJ&�^�q,s����oP1<̡��ĐDD�vU��1�&���l�f3�_�0u�	Ɯ��|����7�s�-�� ����	�(��Q�]���c���~���^��k �	`�f��|��>}�#�7�G.��} 9�~����=��m����{���Ag\��0��sF�fC>��Jd�2��;�dĵ�$��w�]|���� ���w�� +]�(k�@JٖG\�D��kh����E�Pҝ�p�Ͳ�yG\��@N��Q1L��߾�����^O��W'�y�7�vpE�}/4�|���u��sCy �8�R��~��������Qj���w�n(e|�b:��J�����9_�M��/8&^J�QJ;�k�H1#tX��������`v��n��,n�y�0fh���������U|�ա�z>�٧������2��UZ��JJ���Ń�T� ��P�u�k��w*
����߽��T��������Ҵ�Id���zy��%q�\�c�ZP��y}q�+@���vǂ�K��)�ѣB�֝c�fA�:�������GTT����#�yc�G�Z�G�hq���T�������~}'>6eGtUɮ��=k�w�i����j|^�\_0VZ��uJ��A�u����9��6�,���_GK��1�*ơ�;����#�~7E��і;F'q�qO5�)*ǂ�'ړc�;��Sr���[O~ @  �~G�22�u?����ק�u�"w����O�?�/�[9����l�H�������`��N���2wXr�p�<>́Qc[z��U�� �b�->��王AšZ��U���||����q��D	w�;����=���)��}>���Qq֔qr�7������N$�wnq�0�a��O���i������,�!�lG>�M�IW�3���,�[I����]�������Ix�Ձ5os�1�@r�FX�O�l����;&.h����tr>�����1���K^�4�{�Xn�cdb~�+�zq؈u: w��ȊW7<��#>�2����~��yY��X-�����vݰ7�@���oq��ó[�l%>�Q�`��yHá��_M03��:癢����>�)>�в��a��,:�G���d�t8:Yjq+�&��tX0{���SiΊ[z�][b��C�G\A�9�Gp��@J\��� ����۪,��8�-r���u�߈.>laj���M0f����Gt��j|����x3����}����v[�_o��� ��`Ezf�&�p�y�����C��!+&Xhu�V�+xϸo��Gڤ��L��WT��W����7��n�I?�B���_މY���t|a�t���ŷ��֘�fV����+^�n�%�c{#�f�(G����#�8����~�?��Wv$��c�w�ӆ�O~#��n�%p����ѮI��x�m$> 94�:V	�8.��� /8V����������J%��Fb��> >Oе�ꈟ�--��B��[���l�a.{�&��c9h���3>�`V~�.����������������          �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    17443    NYCountyAidCrime    DATABASE     v   CREATE DATABASE "NYCountyAidCrime" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1252';
 "   DROP DATABASE "NYCountyAidCrime";
                postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   postgres    false    3            �            1255    17585    update_aidamount()    FUNCTION     �  CREATE FUNCTION public.update_aidamount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
  UPDATE NYAidCrimeMean
  set AidAmount_mean = sub_q.newaidmean, Aidpercap = sub_q.newaidmean / sub_q.newpopmean
  from (select avg(new.aidAmount) as newaidmean, avg(new.population) as newpopmean from NYAidCrimeTimeSeries where county = old.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$$;
 )   DROP FUNCTION public.update_aidamount();
       public          postgres    false    3            �            1255    17635    update_aidamountmean()    FUNCTION     �  CREATE FUNCTION public.update_aidamountmean() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
  UPDATE NYAidCrimeMean
  set AidAmount_mean = sub_q.newaidmean, Aidpercap = sub_q.newaidmean / sub_q.newpopmean
  from (select avg(new.aidAmount) as newaidmean, avg(new.population) as newpopmean from NYAidCrimeTimeSeries where county = old.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$$;
 -   DROP FUNCTION public.update_aidamountmean();
       public          postgres    false    3            �            1255    17591    update_capaidamount()    FUNCTION     v  CREATE FUNCTION public.update_capaidamount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
  UPDATE NYAidCrimeMean
  set Aidpercap = sub_q.newaidmean / sub_q.newpopmean
  from (select avg(aidAmount) as newaidmean, avg(population) as newpopmean from NYAidCrimeTimeSeries where county = old.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$$;
 ,   DROP FUNCTION public.update_capaidamount();
       public          postgres    false    3            �            1255    17600    update_crimesmean()    FUNCTION     �  CREATE FUNCTION public.update_crimesmean() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
  UPDATE NYAidCrimeMean
  set CrimesReported_mean = sub_q.newcrimesmean, crimesPerCap = sub_q.newcrimesmean / sub_q.newpopmean
  from (select avg(new.crimesReported) as newcrimesmean, avg(new.population) as newpopmean from NYaidcrimeTimeSeries where county = new.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$$;
 *   DROP FUNCTION public.update_crimesmean();
       public          postgres    false    3            �            1255    17603    update_jailmean()    FUNCTION     U  CREATE FUNCTION public.update_jailmean() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
  UPDATE NYAidCrimeMean
  set JailPopulation_mean = sub_q.newJailmean
  from (select avg(new.JailPopulation) as newJailmean from NYAidcrimeTimeSeries where county = new.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$$;
 (   DROP FUNCTION public.update_jailmean();
       public          postgres    false    3            �            1255    17597    update_populationmean()    FUNCTION       CREATE FUNCTION public.update_populationmean() RETURNS trigger
    LANGUAGE plpgsql
    AS $$  
BEGIN
  UPDATE NYAidCrimeMean
  set Population_mean = sub_q.newpopmean, Aidpercap = sub_q.newaidmean / sub_q.newpopmean, CrimesPerCap = sub_q.newcrimemean / sub_q.newpopmean
  from (select avg(new.aidAmount) as newaidmean, avg(new.population) as newpopmean, avg(new.CrimesReported) as newcrimemean from NYAidCrimeTimeSeries where county = new.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$$;
 .   DROP FUNCTION public.update_populationmean();
       public          postgres    false    3            �            1259    17637    nyaidcrimemean    TABLE       CREATE TABLE public.nyaidcrimemean (
    county character varying(50) NOT NULL,
    aidamount_mean integer,
    population_mean integer,
    jailpopulation_mean integer,
    crimesreported_mean integer,
    aidpercap integer,
    crimespercap double precision
);
 "   DROP TABLE public.nyaidcrimemean;
       public         heap    postgres    false    3            �           0    0    TABLE nyaidcrimemean    ACL     �   REVOKE ALL ON TABLE public.nyaidcrimemean FROM postgres;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE ON TABLE public.nyaidcrimemean TO postgres;
          public          postgres    false    200            �            1259    17642    nyaidcrimetimeseries    TABLE     �   CREATE TABLE public.nyaidcrimetimeseries (
    county character varying(50) NOT NULL,
    year integer NOT NULL,
    aidamount integer,
    population integer,
    jailpopulation integer,
    crimesreported integer
);
 (   DROP TABLE public.nyaidcrimetimeseries;
       public         heap    postgres    false    3            �          0    17637    nyaidcrimemean 
   TABLE DATA           �   COPY public.nyaidcrimemean (county, aidamount_mean, population_mean, jailpopulation_mean, crimesreported_mean, aidpercap, crimespercap) FROM stdin;
    public          postgres    false    200   �       �          0    17642    nyaidcrimetimeseries 
   TABLE DATA           s   COPY public.nyaidcrimetimeseries (county, year, aidamount, population, jailpopulation, crimesreported) FROM stdin;
    public          postgres    false    201   V       +           2606    17641 "   nyaidcrimemean nyaidcrimemean_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.nyaidcrimemean
    ADD CONSTRAINT nyaidcrimemean_pkey PRIMARY KEY (county);
 L   ALTER TABLE ONLY public.nyaidcrimemean DROP CONSTRAINT nyaidcrimemean_pkey;
       public            postgres    false    200            -           2606    17646 .   nyaidcrimetimeseries nyaidcrimetimeseries_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.nyaidcrimetimeseries
    ADD CONSTRAINT nyaidcrimetimeseries_pkey PRIMARY KEY (county, year);
 X   ALTER TABLE ONLY public.nyaidcrimetimeseries DROP CONSTRAINT nyaidcrimetimeseries_pkey;
       public            postgres    false    201    201            /           2620    17652 6   nyaidcrimetimeseries update_aidamountmean_after_update    TRIGGER     �   CREATE TRIGGER update_aidamountmean_after_update AFTER UPDATE ON public.nyaidcrimetimeseries FOR EACH ROW EXECUTE FUNCTION public.update_aidamount();
 O   DROP TRIGGER update_aidamountmean_after_update ON public.nyaidcrimetimeseries;
       public          postgres    false    202    201            0           2620    17653 3   nyaidcrimetimeseries update_crimesmean_after_update    TRIGGER     �   CREATE TRIGGER update_crimesmean_after_update AFTER UPDATE ON public.nyaidcrimetimeseries FOR EACH ROW EXECUTE FUNCTION public.update_crimesmean();
 L   DROP TRIGGER update_crimesmean_after_update ON public.nyaidcrimetimeseries;
       public          postgres    false    201    216            1           2620    17654 1   nyaidcrimetimeseries update_jailmean_after_update    TRIGGER     �   CREATE TRIGGER update_jailmean_after_update AFTER UPDATE ON public.nyaidcrimetimeseries FOR EACH ROW EXECUTE FUNCTION public.update_jailmean();
 J   DROP TRIGGER update_jailmean_after_update ON public.nyaidcrimetimeseries;
       public          postgres    false    217    201            2           2620    17655 7   nyaidcrimetimeseries update_populationmean_after_update    TRIGGER     �   CREATE TRIGGER update_populationmean_after_update AFTER UPDATE ON public.nyaidcrimetimeseries FOR EACH ROW EXECUTE FUNCTION public.update_populationmean();
 P   DROP TRIGGER update_populationmean_after_update ON public.nyaidcrimetimeseries;
       public          postgres    false    218    201            .           2606    17647 5   nyaidcrimetimeseries nyaidcrimetimeseries_county_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.nyaidcrimetimeseries
    ADD CONSTRAINT nyaidcrimetimeseries_county_fkey FOREIGN KEY (county) REFERENCES public.nyaidcrimemean(county);
 _   ALTER TABLE ONLY public.nyaidcrimetimeseries DROP CONSTRAINT nyaidcrimetimeseries_county_fkey;
       public          postgres    false    2859    200    201           