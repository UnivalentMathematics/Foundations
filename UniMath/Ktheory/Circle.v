(** * Construction of the circle *)

(** We will show that [B ℤ] has the universal property of the circle. *)

Unset Automatic Introduction.
Require Import AffineLine algebra1b funextfun Utilities auxiliary_lemmas_HoTT GroupAction hz.
Require pathnotations.
Import pathnotations.PathNotations Utilities.Notation.
Delimit Scope paths_scope with paths.
Open Scope paths_scope.
Local Notation "g + x" := (ac_mult _ g x) : action_scope.
Notation ℕ := nat.
Notation ℤ := hzaddabgr.

Theorem loops_circle : weq (Ω (B ℤ)) ℤ.
Proof. apply loopsBG. Defined.

Definition circle_loop := invmap loops_circle 1 : Ω (B ℤ).

Lemma loop_compute t : castTorsor circle_loop t == one + t.
Proof. intros. exact (loopsBG_comp _ one t @ commax _ t one). Defined.

(** * Powers of paths *) 

Definition loop_power_nat {Y} {y:Y} (l:y==y) (n:ℕ) : y==y.
Proof. intros. induction n as [|n p]. 
       { exact (idpath _). } { exact (p@l). } Defined.

Local Notation "l ^ n" := (loop_power_nat l n) : paths_nat_scope.

Definition loop_power {Y} {y:Y} (l:y==y) (n:ℤ) : y==y.
Proof. intros. assert (m := loop_power_nat l (hzabsval n)).
       destruct (hzlthorgeh n 0%hz). { exact (!m). } { exact m. } Defined.

Local Notation "l ^ n" := (loop_power l n) : paths_scope.

(** ** The total space of guided homotopies over BZ *)

Definition ZGuidedHomotopy {Y} {y:Y} (l:y==y) (T:Torsor ℤ) := 
  GuidedHomotopy (confun T y) (confun T l).

Definition GH {Y} {y:Y} (l:y==y) := total2 (ZGuidedHomotopy l).

Definition GHpair {Y} {y:Y} (l:y==y) (T:Torsor ℤ) (g:ZGuidedHomotopy l T) :=
  tpair (ZGuidedHomotopy l) T g.

Definition pr1_GH {Y} {y:Y} {l:y==y} := pr1 : GH l -> Torsor ℤ.

Definition pr2_GH {Y} {y:Y} (l:y==y) (u:GH l) 
  := pr2 u : ZGuidedHomotopy l (pr1_GH u).

Definition GH_path3 {Y} {y:Y} (l:y==y) {T:Torsor ℤ} {y':Y}
           {g g':GHomotopy (confun T y) (confun T l) y'} (u:g==g') :
  GHpair l T (tpair _ y' g ) == GHpair l T (tpair _ y' g' ).
Proof. intros. destruct u. reflexivity. Defined.

Definition pr12_GH {Y} {y:Y} {l:y==y} (u:GH l) := pr1 (pr2_GH l u) : Y.

Definition pr22_GH {Y} {y:Y} {l:y==y} (u:GH l)
     := pr2 (pr2_GH l u) 
     : GHomotopy (confun (pr1_GH u) y) (confun (pr1_GH u) l) (pr12_GH u).

Definition GH_path3_comp1 {Y} {y:Y} (l:y==y) {T:Torsor ℤ} {y':Y}
           {g g':GHomotopy (confun T y) (confun T l) y'} (u:g==g') :
  ap pr1_GH (GH_path3 l u) == idpath T.
Proof. intros. destruct u. reflexivity. Defined.

Definition GH_path3_comp2 {Y} {y:Y} (l:y==y) {T:Torsor ℤ} {y':Y}
           {g g':GHomotopy (confun T y) (confun T l) y'} (u:g==g') :
  ap pr12_GH (GH_path3 l u) == idpath y'.
Proof. intros. destruct u. reflexivity. Defined.

Lemma pr1_GH_isweq {Y} {y:Y} (l:y==y) : isweq (@pr1_GH Y y l).
Proof. intros. apply isweqpr1. intros T. apply iscontrGuidedHomotopy.
Defined.

Definition pr1_GH_weq {Y} {y:Y} (l:y==y) : weq (GH l) (Torsor ℤ)
   := weqpair pr1_GH (pr1_GH_isweq l).

Definition makeGH {Y} {y:Y} (l:y==y) (T:Torsor ℤ) (t:T) {y':Y} (h:y'==y) 
           : GH l
  := GHpair l T (makeGuidedHomotopy _ _ t h).

(** ** Various paths in GH *)

Definition makeGH_localPath {Y} {y:Y} (l:y==y) (T:Torsor ℤ) {t t':T} (r:t==t')
           {y'} {h h':y'==y} (q:h==h') 
  : makeGH l T t h == makeGH l T t' h'.
Proof. intros. destruct q, r. reflexivity. 
(* compare with [makeGuidedHomotopy_localPath] *)
Defined.

Definition makeGH_localPath_comp1 {Y} {y:Y} (l:y==y) (T:Torsor ℤ) {t t':T} (r:t==t')
           {y'} {h h':y'==y} (q:h==h') : 
  ap pr1_GH (makeGH_localPath l T r q) == idpath T.
Proof. intros. destruct q,r. reflexivity. Defined.

Definition makeGH_localPath_comp2 {Y} {y:Y} (l:y==y) (T:Torsor ℤ) {t t':T} (r:t==t')
           {y'} {h h':y'==y} (q:h==h') : 
  ap pr12_GH (makeGH_localPath l T r q) == idpath y'.
Proof. intros. destruct q,r. reflexivity. Defined.

Definition makeGH_verticalPath {Y} {y:Y} (l:y==y) {T:Torsor ℤ} (t:T)
           {y' y''} (h:y'==y) (p:y''==y')
  : makeGH l T t (p@h) == makeGH l T t h.
Proof. intros. destruct p. reflexivity. Defined.
(* could also use [makeGuidedHomotopy_verticalPath] *)

Definition makeGH_verticalPath_comp1 {Y} {y:Y} (l:y==y) {T:Torsor ℤ} (t:T)
           {y' y''} (h:y'==y) (p:y''==y')
  : ap pr1_GH (makeGH_verticalPath l t h p) == idpath T.
Proof. intros. destruct p. reflexivity. Defined.

Definition makeGH_verticalPath_comp2 {Y} {y:Y} (l:y==y) {T:Torsor ℤ} (t:T)
           {y' y''} (h:y'==y) (p:y''==y')
  : ap pr12_GH (makeGH_verticalPath l t h p) == p.
Proof. intros. destruct p. reflexivity. Defined.

Definition makeGH_horizontalPath {Y} {y:Y} (l:y==y) {T T':Torsor ℤ} (q:T==T')
           (t:T) {y'} (h:y'==y)
  : makeGH l T t h == makeGH l T' (castTorsor q t) h.
Proof. intros. destruct q. reflexivity. 
(* compare with [makeGuidedHomotopy_horizontalPath] *)
Defined.

Definition makeGH_horizontalPath_comp1 {Y} {y:Y} (l:y==y) {T T':Torsor ℤ} (q:T==T')
           (t:T) {y'} (h:y'==y)
  : ap pr1_GH (makeGH_horizontalPath l q t h) == q.
Proof. intros. destruct q. reflexivity. Defined.

Definition makeGH_horizontalPath_comp2 {Y} {y:Y} (l:y==y) {T T':Torsor ℤ} (q:T==T')
           (t:T) {y'} (h:y'==y)
  : ap pr12_GH (makeGH_horizontalPath l q t h) == idpath y'.
Proof. intros. destruct q. reflexivity. Defined.

Definition makeGH_transPath {Y} {y:Y} (l:y==y) {T:Torsor ℤ} (t:T) {y'} (h:y'==y)
  : makeGH l T t h == makeGH l T (one+t) (h@l).
Proof. intros. apply GH_path3.
       (* copied from the proof of [makeGuidedHomotopy_transPath] *)
       exact (ℤTorsorRecursion_transition_inv 
                _ (fun t => weq_pathscomp0r y' l) _ _). Defined.

Definition makeGH_transPath_comp1 {Y} {y:Y} (l:y==y) {T:Torsor ℤ} (t:T) {y'} (h:y'==y)
  : ap pr1_GH (makeGH_transPath l t h) == idpath T.
Proof. intros. exact (GH_path3_comp1 l _). Defined.

Definition makeGH_transPath_comp2 {Y} {y:Y} (l:y==y) {T:Torsor ℤ} (t:T) {y'} (h:y'==y)
  : ap pr12_GH (makeGH_transPath l t h) == idpath y'.
Proof. intros. exact (GH_path3_comp2 l _). Defined.

Definition makeGH1 {Y} {y:Y} (l:y==y) (T:Torsor ℤ) (t:T) : GH l
  := makeGH l T t (idpath y).

Definition makeGH_diagonalLoop {Y} {y:Y} (l:y==y) {T:Torsor ℤ} (t:T) 
           (q:T==T) (r:castTorsor q t == one + t) : 
  makeGH1 l T t == makeGH1 l T t.
Proof. intros.
       assert (p2 := makeGH_transPath l t (idpath y)).
       assert (p0:= makeGH_localPath l T (!r) (idpath l)); clear r.
       assert (ph := makeGH_horizontalPath l q t l).
       assert (p1 := makeGH_localPath l T (idpath t) (! pathscomp0rid l)).
       assert (pv := makeGH_verticalPath l t (idpath y) l).
       assert (p := p2 @ p0 @ !ph @ p1 @ pv); clear p2 p0 ph p1 pv.
       exact p. Defined.

Definition makeGH_diagonalLoop_comp1 {Y} {y:Y} (l:y==y) {T:Torsor ℤ} (t:T) 
           (q:T==T) (r:castTorsor q t == one + t) : 
  ap pr1_GH (makeGH_diagonalLoop l t q r) == !q.
Proof. intros. unfold makeGH_diagonalLoop.
       refine (ap_natl (makeGH_transPath_comp1 _ _ _) _).
       refine (ap_natl (makeGH_localPath_comp1 _ _ _ _) _).
       rewrite <- (pathscomp0rid (! q)).
       refine (ap_natl' (makeGH_horizontalPath_comp1 _ _ _ _) _).
       rewrite <- (pathscomp0rid (idpath T)).
       refine (ap_natl (makeGH_localPath_comp1 _ _ _ _) _).
       exact (makeGH_verticalPath_comp1 _ _ _ _).
Defined.

Definition makeGH_diagonalLoop_comp2 {Y} {y:Y} (l:y==y) {T:Torsor ℤ} (t:T) 
           (q:T==T) (r:castTorsor q t == one + t) : 
  ap pr12_GH (makeGH_diagonalLoop l t q r) == l.
Proof. intros. unfold makeGH_diagonalLoop.
       refine (ap_natl (makeGH_transPath_comp2 _ _ _) _).
       refine (ap_natl (makeGH_localPath_comp2 _ _ _ _) _).
       refine (ap_natl' (makeGH_horizontalPath_comp2 _ _ _ _) _).
       refine (ap_natl (makeGH_localPath_comp2 _ _ _ _) _).
       exact (makeGH_verticalPath_comp2 _ _ _ _).
Defined.

(** ** The universal property of the circle *)

Definition circle_map {Y} {y:Y} (l:y==y) : B ℤ -> Y.
Proof. intros ? ? ?. exact (funcomp (invmap (pr1_GH_weq l)) pr12_GH). Defined.

Definition circle_map_check_values {Y} {y:Y} (l:y==y) : 
  circle_map l (basepoint (B ℤ)) == y.
Proof. reflexivity.              (* don't change the proof *)
(** This proof works because the trivial torsor has an
    actual point that provides the accompanying proof of nonemptiness. *)
Defined.

Definition circle_map_check_values_understand {Y} {y:Y} (l:y==y) (T:Torsor ℤ) : 
  circle_map l T == y.
Proof. intros.
       unfold circle_map, funcomp, invmap, pr12_GH.
       simpl.
       unfold pr1_GH_isweq.
       simpl.
       unfold iscontrGuidedHomotopy.
       (** Not possible, but look at the goal.
           It's stuck on [squash_to_prop (torsor_nonempty T0)].
           If [torsor_nonempty T0] were explicitly obtained as
           [squash_element t0] for some [t0], this would simplify
           further: see [squash_to_prop_compute]. *)
       admit.
Defined.

Definition loop_correspondence {T X Y}
           (f:weq T X) (g:T->Y)
           {t t':T} {l:t==t'}
           {m:f t==f t'} (mi:ap f l == m)
           {n:g t==g t'} (ni:ap g l == n) : 
     ap (funcomp (invmap f) g) m @ ap g (homotinvweqweq f t') 
  == ap g (homotinvweqweq f t) @ n.
Proof. intros. destruct ni, mi, l. simpl. rewrite pathscomp0rid. reflexivity.
Defined.

Definition loop_correspondence2 {X Y:Type} {P:X->Y->Type}
           (h:X->Y)
           {x0:X} (p0:P x0 (h x0)) 
           (p:forall x, P x (h x))
           (cntr:forall x, forall t:total2 (P x), t == tpair (P x) (h x) (p x)) : 
  let y0 := h x0 in
  let Q := fun x => total2 (P x) in
  let T := total2 Q in
  let is := fun x => @tpair (total2 (P x)) (fun cntr => forall t, t == cntr)
                      (tpair (P x) (h x) (p x))
                      (cntr x) in
  let pr1_weq := weqpair pr1 (isweqpr1 _ is) : weq T X in
  let t0 := invmap pr1_weq x0 in
  let pr12 := fun t:T => pr1 (pr2 t) in
  let x0' := pr1_weq t0 in
  let h' := funcomp (invmap pr1_weq) pr12 in
  let t0' := @tpair X Q x0 (@tpair Y (P x0) y0 p0) : T in
  unit.
Proof. intros. 
       compute in t0.
       Check idpath _ : pr1_weq t0 == x0.
       Check idpath _ : pr1_weq t0 == x0.
       compute in x0'.
       Check idpath _ : pr12 t0 == y0.
       Check idpath _ : h' x0 == y0.
       Check idpath _ : pr1_weq t0' == x0.
       Check idpath _ : pr12 t0' == y0.
       (* Check idpath _ : invmap pr1_weq (pr1_weq t0') == t0'. *)


       exact tt.
Defined.

Definition pathsinv0_to_right {X} {x y z:X} (p:y==x) (q:y==z) (r:x==z) :
  q == p @ r -> !p @ q == r.
Proof. intros ? ? ? ? ? ? ? e. destruct p, q. exact e. Defined.

Definition pathsinv0_to_right' {X} {x y:X} (p:y==x) (r:x==y) :
  idpath _ == p @ r -> !p == r.
Proof. intros ? ? ? ? ? e. destruct p. exact e. Defined.

Definition pathsinv0_to_right'' {X} {x:X} (p:x==x) :
  idpath _ == p -> !p == idpath _.
Proof. intros ? ? ? e. apply pathsinv0_to_right'. rewrite pathscomp0rid.
       exact e. Defined.

Definition pr2_of_hfiberpair {X Y} {f:X->Y} {x:X} {y:Y} {e:f x==y} :
  pr2 (hfiberpair f x e) == e.
Proof. reflexivity. Defined.

Definition pr2_of_pair {X} {P:X->Type} (x:X) (p:P x) : pr2 (@tpair X P x p) == p.
Proof. reflexivity. Defined.

Definition pr2_of_weqpair {X Y} (f:X->Y) (i:isweq f) : pr2 (weqpair f i) == i.
Proof. reflexivity. Defined.

Definition circle_map_check_paths {Y} {y:Y} (l:y==y) : 
  ap (circle_map l) (! circle_loop) == l.
Proof. intros. set (T := basepoint (B ℤ)); simpl in T. set (t0 := 0:T).
       assert (c1 := makeGH_diagonalLoop_comp1 l _ _ (loop_compute t0)).
       assert (c2 := makeGH_diagonalLoop_comp2 l _ _ (loop_compute t0)).
       unfold circle_map.
       assert (c := loop_correspondence (pr1_GH_weq l) pr12_GH c1 c2).
       set (gh := makeGH1 l _ t0).
       (* to see that gh is an explicit triple T,,y,,..., do this: *)
       unfold makeGH1,makeGH,GHpair,makeGuidedHomotopy in gh.
       Check idpath _ : circle_map l T == y.
       Check (fun T => pr22_GH (invmap (pr1_GH_weq l) T)).
       Check @loop_correspondence2
             (Torsor ℤ)
             Y 
             (fun T => GHomotopy (confun T y) (confun T l))
             (circle_map l)
             T 
             (pr2 (pr2 (invmap (pr1_GH_weq l) T)))
       .
             (* (fun T => pr22_GH (invmap (pr1_GH_weq l) T)) *)

       set (gamma := makeGH_diagonalLoop l t0 circle_loop (loop_compute t0)).
       Check gamma : gh == gh.
       set (e := homotinvweqweq (pr1_GH_weq l) gh).
       Check ap pr1_GH e : T == T.
       Check e : _ == gh.
       (* Check e : gh == _. *)
       set (d := ap pr12_GH e).
       Check d : y == y.
       assert (d == idpath y).
       { unfold d,e,gh.
         unfold makeGH1,makeGH,GHpair,makeGuidedHomotopy.
         unfold homotinvweqweq,homotinvweqweq0.
         rewrite maponpathsinv0.
         (* should work: apply pathsinv0_to_right''. *)
         rewrite <- (pathsinv0inv0 (idpath y)).
         apply (ap pathsinv0).
         rewrite (pathsinv0inv0 (idpath y)).
         change (! idpath y) with (idpath y).
         unfold pr1_GH_weq.
         (* should work: rewrite (pr2_of_weqpair pr1_GH). *)
         (* maybe use adjointness [homotweqinvweqweq] *)


         admit. }
       admit.
Defined.

(*
Local Variables:
compile-command: "make -C ../.. UniMath/Ktheory/Circle.vo"
End:
*)

