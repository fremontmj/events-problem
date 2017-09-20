open Tea.App
open Tea.Html

let (!) a = (a, Tea.Cmd.none)

type msg =
  | Increment
  | StartAnimation
  | AnimationUpdate
  [@@bs.deriving {accessors}]


let init () = 
  let _onthing = () in
  ! 4

external jsAnimationUpdate : unit -> unit = "jsAnimationUpdate" [@@bs.val]

let update model msg = 
  match msg with
  | Increment ->
    ! (model + 1)
  | StartAnimation ->
      let () = jsAnimationUpdate () in
        ! model
  | AnimationUpdate ->
      let () = Js.log("got AnimationUpdate message") in
        ! model

let view_button title msg =
  button
    [ onClick msg
    ]
    [ text title
    ]

let view model =
  div
    []
    [ span
        [ style "text-weight" "bold" ]
        [ text (string_of_int model) ]
    ; br []
    ; view_button "Increment" Increment
    ; view_button "Start Animating" StartAnimation
    ]


    let subscriptions _model = 
      Tea.Mouse.registerGlobal "animationUpdate" "aUniqueKey" (fun _event -> 
        let () = Js.log "in subscription" in
          AnimationUpdate)

let main =
  standardProgram {
    init; 
    update;
    subscriptions;
    view;
  }
